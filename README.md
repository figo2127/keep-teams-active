# Keep Teams Active

A small Windows tool that stops Microsoft Teams from switching your status to **Away** (yellow) when you haven't touched your keyboard or mouse for a while.

You get one icon on your desktop. Double-click it to turn it **on**. Double-click it again to turn it **off**. That's it.

> **Windows only.** It doesn't work on Mac.

---

## Install (one time, about 2 minutes)

### 1. Download

At the top of this page, click the green **`<> Code`** button, then click **Download ZIP**.

### 2. Unzip

1. Open your **Downloads** folder.
2. Right-click **keep-teams-active-main.zip** and choose **Extract All…**, then click **Extract**.
3. A new folder opens. Keep it open.

> ⚠️ Don't skip this step. If you double-click files while they're still inside the ZIP, the install won't work.

### 3. Run the installer

1. In the unzipped folder, double-click **Install.bat**.
2. Windows might show a blue box that says **"Windows protected your PC."** This happens with any file downloaded from the internet. Click **More info**, then **Run anyway**.
3. A black window appears and says **Done!** Press any key to close it.

You'll now see a **Keep Teams Active** icon on your desktop. 🎉

---

## How to use it

| To do this | Do this |
|---|---|
| **Turn ON** | Double-click **Keep Teams Active** on your desktop. A small notice says it's ON, and an ⓘ icon appears in the bottom-right corner of your screen, near the clock. |
| **Turn OFF** | Double-click the desktop icon **again**. A small box says **OFF**. |
| **Turn OFF (other way)** | Right-click the ⓘ icon near the clock and click **Stop**. |
| **Check if it's on** | Look for the ⓘ icon near the clock. If you can't see it, click the small **^** arrow next to the clock to show hidden icons. |

It also turns off by itself when you shut down or restart your computer. After a restart, double-click the icon again if you want it back on.

---

## ⚠️ Please read

- **Your screen won't lock by itself while this is ON.** When you walk away from your desk, lock your computer yourself: press the **Windows key + L**.
- **It stops working once your screen is locked.** Teams will show you as Away then. That's normal.
- **Work computers:** some companies don't allow tools like this, and some IT security software may flag it. If you're not sure, ask your IT team before using it.

---

## Remove it

1. Go back to the folder you unzipped in step 2. If you deleted it, download and unzip it again.
2. Double-click **Uninstall.bat**.
3. When it says **Done**, the desktop icon is gone and you can delete the folder.

---

## Something not working?

**I double-clicked the icon and nothing happened.**
Look for the ⓘ icon near the clock (click the **^** arrow to see hidden icons). If it's there, the tool is running. It works quietly in the background.

**The installer window flashed and closed, or showed red error text.**
Your work computer probably blocks scripts like this. Only your IT team can change that.

**I still go Away in Teams.**
- Check that the ⓘ icon is near the clock. If it isn't, the tool is off.
- Remember that it can't keep you active once your screen is locked.

**I don't see "Run anyway" in the blue box.**
Click the small **More info** link first. If you still don't see **Run anyway**, your company has blocked it.

**I moved my desktop icon or deleted it by accident.**
Double-click **Install.bat** again. It puts the icon back.

---

## How it works (for the curious)

About once a minute, the tool presses the **F15** key for you. Most keyboards don't have an F15 key and no program uses it, so it doesn't type anything or interfere with your work. It's enough to tell Windows, and therefore Teams, that you're still there. The tool also keeps your computer from going to sleep while it's on.

There's nothing to pay for, no account, and no internet connection is used. The whole tool is one small script, `KeepTeamsActive.ps1`, that anyone can open in Notepad and read.

<details>
<summary>Advanced options</summary>

- **Change how often the key is pressed** (default is every 60 seconds): open PowerShell in the unzipped folder and run
  `powershell -ExecutionPolicy Bypass -File .\KeepTeamsActive.ps1 -Install -IntervalSec 120`
- **Where things are installed:** the script is copied to `%LOCALAPPDATA%\KeepTeamsActive`, and the shortcut goes on your desktop. Nothing else on your computer is changed, and no admin rights are needed.

</details>

---

## License

MIT. Free to use, change, and share. See [LICENSE](LICENSE).
