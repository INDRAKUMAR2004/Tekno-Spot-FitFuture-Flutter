const admin = require("firebase-admin");
const fs = require("fs");

const serviceAccount = require("./serviceAccountKey.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const users = JSON.parse(fs.readFileSync("uploadStudents.js", "utf8"));

async function importUsers() {
  for (const user of users) {
    try {
      const createdUser = await admin.auth().createUser({
        email: user.email,
        password: user.password,
        displayName: user.name,
      });
      console.log(`✅ Created: ${user.email}`);
    } catch (error) {
      if (error.code === "auth/email-already-exists") {
        console.log(`⚠️ Skipped (already exists): ${user.email}`);
      } else {
        console.error(`❌ Error for ${user.email}:`, error.message);
      }
    }
  }
  console.log("🎉 Import complete!");
}

importUsers();
