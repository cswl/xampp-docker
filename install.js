#!/usr/bin/env node

// Script to launch and kill the installer
// Because it gets stuck

const { spawn } = require("child_process");
const installer = spawn("./xampp-linux-installer.run", ["--mode", "text"]);

installer.stdout.on("data", data => {
  const str = data.toString();
  if (str.startsWith("#")) {
    process.stdout.write(`${data}`);
  } else {
    process.stdout.write(`stdout: ${str}`);
  }

  // Answer 'y' to everything in stdin
  installer.stdin.write("y\n");

  // Installer has finished installing.. so just kill it.
  if (str.includes("Setup has finished installing")) {
    console.log("Killing subprocess....");
    installer.kill("SIGTERM");
    // Let the nodejs process exit gracefully.
    process.exitCode = 0;
  }
});

installer.stderr.on("data", data => {
  console.log(`stderr: ${data}`);
});

installer.on("close", code => {
  console.log("Subprocess killed");
});
