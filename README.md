# Ticketry - Description
Ticketry is a Windows 10/11 forensic tool related to Windows activation. Formerly known as _ticket-util_ or _Ticket Utility_, it is intended for forensic and experimental use. There are several variations in which you can help contribute to add new features and test in a lab environment:
1. `stta.exe` - First edition that was developed. It requires online access to install the Windows 10 1607 ADK cabinet installer. After this, it is offline, and no external steps are needed that require an online network connection. Extends the potential for forensic and lab learning.
2. `stta2.exe` - Second edition that was developed. It requires online access to refer to [asdcorp\WindowsRentFree tickets](https://github.com/asdcorp/WindowsRentFree/Tickets) and pull them based on the system Pfn (_product family name_) under the registry key **HKLM\SYSTEM\CurrentControlSet\Control\ProductOptions** at subkey **OSProductPfn**. Useful for speed.
3. `stta3.exe` - Third edition that was developed. It requires online access to fetch tickets from the same repository as `stta2.exe`, but only activates the current edition of Windows. Useful for speed.
4. `ostta.exe` - Fourth (and previously Fifth before ticketgen.com was scrapped) edition that was developed. It is supported offline and instead creates a patched version of `gatherosstate.exe` manually by writing the bytes of an existing _gatherosstate.exe_ file and creates the GatherOsState file as so. It can be considered the most helpful, as it supports offline and online environments, but the _$raw_ variable defined in the script (PS1) is large.

Each of these executables was compiled using the `PS2EXE` module. To extract and analyze one of these files for yourself, install the desired, open PowerShell as an Administrator, and execute these commands:
```PowerShell
cd "$parent-directory-of-file"
.\$name-of-downloaded -extract:$name-of-extracted
```
It will return as a _.ps1_ PowerShell file.
You can see the [license](../main/LICENSE.md) file for more information on the safety of the file, distributing rights, and copyright under the public domain.
# The technology behind these utilities
## STTA.exe
`stta.exe` maps editions of Windows 10 and 11 in a predefined variable known as _$editions_, where it then prompts for edition while displaying a list of all editions available (currently 32 available editions, others will contain 31, but you can help by contributing). After selecting, it will display the product family name of the edition and the generic RTM _(Release-to-Manufacturer)_ product key. After this, it will fetch the _Windows 10 1607 ADK_ cabinet installer (although it may prompt to create C:\Files, you should allow it and you can remove the directory after execution) extract the file encrypted, then `gatherosstate.exe`, renames it to `gatherosstate.exe`, executes it with the provided Pfn variable and an existing Confirmation ID (at $PKeyIID). It also prompts to move it to `C:\ProgramData\Microsoft\Windows\ClipSVC\GenuineTicket`. Administrator access is required to access this directory. It will create a file known as **GenuineTicket.xml**, previously but now obsolete, known as a free upgrade path from versions below Windows 10, and reserving hardware activation status. It can then prompt you to enter the product key of the edition you selected and attempt activation.
## STTA2.exe
`stta2.exe` also maps editions of Windows 10 and 11 in the same predefined variable, also prompts and lists editions. After selecting, it will also display the product family name of the edition you selected, as well as its generic RTM product key. However, it fetches existing, prebuilt tickets from an existing repository known as [asdcorp\WindowsRentFree\tickets](https://github.com/asdcorp/WindowsRentFree/Tickets), where it will use _cURL_ to get the prebuilt ticket you need based on the Pfn of the selected edition. It will then prompt to activate Windows by entering the generic product key and attempting activation. It opens Settings to confirm your status.
## STTA3.exe
`stta3.exe` will get your system product family name from `HKLM:\SYSTEM\CurrentControlSet\Control\ProductOptions` at the subkey `OSProductPfn` and store it to a variable known as _$Pfn_, and use **cURL** as well to get the existing, prebuilt ticket from `https://github.com/asdcorp/WindowsRentFree/Tickets/$Pfn.xml`, and then proceeds to move the file to `C:\ProgramData\Microsoft\Windows\ClipSVC\GenuineTicket`, and it also attempts activation by entering the product key based on your subkey `HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion` _EditionID_ and searches a list of generic product keys in the variable _$prk_ and looks for a key that is listed under your edition. It will then open Settings for you to confirm your status.
## OSTTA.exe
`ostta.exe` is very similar to `stta.exe`, but supports offline environments by manually crafting a `gatherosstate.exe` file using the bytes from an existing and patched `gatherosstate.exe` and generating a ticket as so. Downsides of this method can be caused by the large variable _$raw_, which represents the bytes that will be converted to actual data (as _$bytes_) to then write to the file.

These executables work on _PowerShell 5.1_ and higher; however, some features may be deprecated for new versions of **PowerShell**, and, if so, it is advised to contribute and change to support such versions.

# How does this affect Windows activation?
`GenuineTicket.xml` affects Windows activation by introducing hardware activation from the ticket. Originally, `gatherosstate.exe` will only create _GenuineTicket.xml_ if the PC followed the condition(s) below:
- The installation of Windows 7, the 8.xx family, and previous versions to Windows 10 must be activated. This was the key condition.

However, these tools, excluding all except `stta.exe` and `ostta.exe`, where the others use prebuilt tickets, use a patched version that will create a ticket file, even if the system is not activated or has invalid activation data. The process can be explained through this chart:
<img width="942" height="621" alt="Diagram of how GenuineTicket.xml is used" src="https://github.com/user-attachments/assets/957b8349-d5f0-4208-b2f1-5a9f65c52245" />
_(Other services may be included, such as SPPSVC, you can help by contributing to the chart.)_

Each executable utilizes the command:
```Batch
ClipUp.exe -v -o
```
To push the ticket, which makes the system notice the ticket at a faster rate.
# Gray-area notice
This tool can potentially be misused for software piracy and circumvention. It is intended for this tool to be used in forensic, educational, and experimental purposes when learning about Microsoft's activation logic.
# Steps to install in Git Bash
Refer to the git-setup-guide file.
# Safety and malware notice
This file has been deemed safe. To read the executable, refer to the description for steps to extract it. If you find the software in the repository hosted elsewhere, you can compare the **SHA256** hashes between the two and attempt to extract both with PS2EXE (The software here is extractable. If the externally hosted software is not, do not execute it).

# Credits
Thank you, Massgrave (or Massgravel) and asdcorp for inspiration and the use of your tools. This tool incorporates a few elements carried over, such as a patch of GatherOsState.exe. 
# Networking notice
Each method requires the device to have at least connected to a network using Ethernet, Wi-Fi, Internet, et cetera. After achieving a valid network connection for the first time, Windows will attempt to activate and register your device. This results in creating a digital license, which will remain on your hardware unless the hardware undergoes a significant change; however, it can be stored on a Microsoft account if the device was set up with one. So, each of these tools in the repository requires your hardware to be registered with Microsoft's licensing and activation servers.
# Compatibility
Setting the compatibility mode of the patched `gatherosstate.exe` file can vary. This was tested on Windows 10 and 11. If you receive the console error where it could not set the compatibility flag registry key, you can safely ignore it.
