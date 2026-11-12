# Keep Teams Active

A small Windows script that stops Microsoft Teams from switching your status to **Away** (yellow) when you haven't touched your keyboard or mouse for a while.

It's one PowerShell file, `KeepTeamsActive.ps1`. You run it yourself when you want it on, and stop it when you're done. Nothing gets installed.

> **Windows only.** It doesn't work on Mac.

---

## Set it up (one time)

You need a copy of `KeepTeamsActive.ps1` on your computer. Pick **one** way:

**Option A: download it**

1. Open [`KeepTeamsActive.ps1`](KeepTeamsActive.ps1) on this page.
2. Click the **Download raw file** button (the ⬇ icon, top-right of the file).
3. Move it to a folder you'll remember, for example `Documents\KeepTeamsActive`.

**Option B: create it yourself** (use this if your work laptop blocks downloaded scripts)

1. Open [`KeepTeamsActive.ps1`](KeepTeamsActive.ps1) on this page and click the **Copy raw file** button (the 📋 icon).
2. Open **Notepad** and paste.
3. Click **File → Save as**. Set **Save as type** to **All files (\*.\*)** and name it `KeepTeamsActive.ps1`. Save it in a folder you'll remember, for example `Documents\KeepTeamsActive`.

> ⚠️ Make sure the name ends in `.ps1`, not `.ps1.txt`.

---

## Turn it on

1. Open the folder that contains `KeepTeamsActive.ps1`.
2. Click the folder's address bar, type `powershell`, and press **Enter**. A blue or black PowerShell window opens in that folder.
3. Paste this and press **Enter**:

   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File .\KeepTeamsActive.ps1
   ```

A small notice says it's ON, and an ⓘ icon appears in the bottom-right corner of your screen, near the clock. **Leave the PowerShell window open** (you can minimize it).

## Turn it off

Any of these works:

- Right-click the ⓘ icon near the clock and click **Stop**.
- Close the PowerShell window.
- Run the same command again in another PowerShell window. A small box says **OFF**.

It also stops when you shut down, restart, or sign out.

**Can't see the ⓘ icon?** Click the small **^** arrow next to the clock to show hidden icons.

---

## ⚠️ Please read

- **Your screen won't lock by itself while this is ON.** When you walk away from your desk, lock your computer yourself: press the **Windows key + L**.
- **It stops working once your screen is locked.** Teams will show you as Away then. That's normal.
- **Work computers:** some companies don't allow tools like this, and some IT security software may flag it. If you're not sure, ask your IT team before using it.

---

## Remove it

Delete `KeepTeamsActive.ps1`. That's all: the script doesn't install anything or change any settings.

---

## Something not working?

**Red text saying "running scripts is disabled on this system" or "cannot be loaded".**
Make sure you used the full command above, including `-ExecutionPolicy Bypass`. If you still see it, your company has locked PowerShell scripts down and only your IT team can change that.

**Red text saying the file "does not exist" or "is not recognized".**
PowerShell isn't open in the right folder, or the file is named `KeepTeamsActive.ps1.txt`. Repeat step 2 of "Turn it on" from inside the folder that has the file, and check the file name.

**I still go Away in Teams.**
- Check that the ⓘ icon is near the clock. If it isn't, the script is off.
- Remember that it can't keep you active once your screen is locked.

---

## How it works (for the curious)

About once a minute, the script presses the **F15** key for you. Most keyboards don't have an F15 key and no program uses it, so it doesn't type anything or interfere with your work. It's enough to tell Windows, and therefore Teams, that you're still there. The script also keeps your computer from going to sleep while it's on.

There's nothing to pay for, no account, and no internet connection is used. Anyone can open `KeepTeamsActive.ps1` in Notepad and read the whole thing.

<details>
<summary>Advanced options</summary>

- **Change how often the key is pressed** (default is every 60 seconds):
  `powershell -NoProfile -ExecutionPolicy Bypass -File .\KeepTeamsActive.ps1 -IntervalSec 120`

</details>

---

## License

MIT. Free to use, change, and share. See [LICENSE](LICENSE).
