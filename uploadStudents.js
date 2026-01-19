// uploadStudents.js
// Reads students.xlsx and creates Firebase Auth users + Firestore docs.
// USAGE: Place students.xlsx and serviceAccountKey.json in same folder and run:
//        node uploadStudents.js

const admin = require("firebase-admin");
const xlsx = require("xlsx");
const fs = require("fs");

// ========================
// 1️⃣ Load Firebase Service Account
// ========================
const SERVICE_ACCOUNT_PATH = "./serviceAccountKey.json";
if (!fs.existsSync(SERVICE_ACCOUNT_PATH)) {
  console.error("❌ ERROR: serviceAccountKey.json not found in folder.");
  console.error("👉 Download it from Firebase Console → Project Settings → Service Accounts");
  process.exit(1);
}
const serviceAccount = require(SERVICE_ACCOUNT_PATH);

// ========================
// 2️⃣ Initialize Firebase Admin SDK
// ========================
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});
const auth = admin.auth();
const db = admin.firestore();

// ========================
// 3️⃣ Load Excel File
// ========================
const EXCEL_FILE = "diet_chart.xlsx"; // Change name if different
if (!fs.existsSync(EXCEL_FILE)) {
  console.error(`❌ ERROR: Excel file "${EXCEL_FILE}" not found in folder.`);
  process.exit(1);
}

const workbook = xlsx.readFile(EXCEL_FILE);
const sheetName = workbook.SheetNames[0];
const sheet = workbook.Sheets[sheetName];
const rows = xlsx.utils.sheet_to_json(sheet, { defval: "" }); // defval prevents undefined

if (!Array.isArray(rows) || rows.length === 0) {
  console.error("❌ ERROR: No rows found in the Excel sheet.");
  process.exit(1);
}

console.log(`📘 Loaded ${rows.length} records from "${EXCEL_FILE}". Starting upload...\n`);

// ========================
// 4️⃣ Helper: Normalize Email
// ========================
function normalizeEmail(e) {
  if (!e) return "";
  return String(e).trim().toLowerCase();
}

// ========================
// 5️⃣ Core Function: Create / Update User + Firestore
// ========================
async function upsertUserAndFirestore(student) {
  // --- Normalize keys (trim + lowercase + compress spaces)
  const normalized = {};
  for (const key of Object.keys(student)) {
    const cleanKey = key.trim().toLowerCase().replace(/\s+/g, " ");
    normalized[cleanKey] = student[key];
  }

  const email = normalizeEmail(normalized["email"]);
  const password = String(normalized["password"] || "").trim();
  const name = normalized["name"] || "";

  if (!email || !password) {
    console.warn(`⚠️ Skipping row due to missing email/password: ${JSON.stringify(student)}`);
    return;
  }

  // --- Create or get user
  let userRecord;
  try {
    userRecord = await auth.createUser({
      email,
      password,
      displayName: name || undefined,
    });
    console.log(`✅ Created new user: ${email}`);
  } catch (err) {
    if (err.code === "auth/email-already-exists") {
      userRecord = await auth.getUserByEmail(email);
      console.log(`ℹ️ Existing user found: ${email}`);
    } else {
      console.error(`❌ Error creating user ${email}:`, err.message);
      return;
    }
  }

  // --- Prepare Firestore document
  const docData = {
    name,
    email,
    password, // ⚠️ Remove in production!
    phone: normalized["phone number"] || "",
    age: normalized["age"] || "",
    gender: normalized["gender"] || "",
    height: normalized["height"] || "",
    weight: normalized["weight"] || "",
    diet: {
      morning: normalized["morning diet"] || "",
      morning_snacks: normalized["morning snacks"] || "",
      afternoon: normalized["afternoon diet"] || "",
      evening_snacks: normalized["evening snacks"] || "",
      night: normalized["night diet"] || "",
    },
    activity: {
      done:
        normalized["activity done"]?.trim() ||
        normalized["activity"]?.trim() ||
        normalized["done"]?.trim() ||
        "",
      calories_burned:
        normalized["calories burned by that activity"] ||
        normalized["calories burned"] ||
        "",
      duration:
        normalized["duration of the activity"] ||
        normalized["activity duration"] ||
        "",
    },
    importedAt: admin.firestore.FieldValue.serverTimestamp(),
  };

  // --- Write Firestore document
  try {
    await db.collection("users").doc(userRecord.uid).set(docData, { merge: true });
    console.log(`📄 Firestore updated for: ${email}`);
  } catch (err) {
    console.error(`❌ Firestore error for ${email}:`, err.message);
  }
}

// ========================
// 6️⃣ Run the Import Process
// ========================
(async () => {
  for (const [index, student] of rows.entries()) {
    console.log(`\n➡️ Processing ${index + 1}/${rows.length}...`);
    try {
      await upsertUserAndFirestore(student);
    } catch (err) {
      console.error(`❌ Failed at row ${index + 1}:`, err.message);
    }
  }

  console.log("\n🎉 Upload complete!");
  process.exit(0);
})();
