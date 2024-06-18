import Foundation

let CYDIAPACKAGE = "cydia://package/com.fake.package"
let NOTJAIL = 4783242
let CYDIALOC = "/Applications/Cydia.app"
let CYDIA = "MobileCydia"
let OTHERCYDIA = "Cydia"
let OOCYDIA = "afpd"
let HIDDENFILES: [String] = [
    "/Applications/RockApp.app",
    "/Applications/Icy.app",
    "/usr/sbin/sshd",
    "/usr/bin/sshd",
    "/usr/libexec/sftp-server",
    "/Applications/WinterBoard.app",
    "/Applications/SBSettings.app",
    "/Applications/MxTube.app",
    "/Applications/IntelliScreen.app",
    "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
    "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
    "/private/var/lib/apt",
    "/private/var/stash",
    "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
    "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
    "/private/var/tmp/cydia.log",
    "/private/var/lib/cydia",
    "/etc/clutch.conf",
    "/var/cache/clutch.plist",
    "/etc/clutch_cracked.plist",
    "/var/cache/clutch_cracked.plist",
    "/var/lib/clutch/overdrive.dylib",
    "/var/root/Documents/Cracked/"
]


// Failed jailbroken checks
enum JailbrokenChecks: Int {
    // Failed the Jailbreak Check
    case KFJailbroken = 3429542
    // Failed the OpenURL Check
    case KFOpenURL = 321
    // Failed the Cydia Check
    case KFCydia = 432
    // Failed the Inaccessible Files Check
    case KFIFC = 47293
    // Failed the plist check
    case KFPlist = 9412
    // Failed the Processes Check with Cydia
    case KFProcessesCydia = 10012
    // Failed the Processes Check with other Cydia
    case KFProcessesOtherCydia = 42932
    // Failed the Processes Check with other other Cydia
    case KFProcessesOtherOCydia = 10013
    // Failed the FSTab Check
    case KFFSTab = 9620
    // Failed the System() Check
    case KFSystem = 47475
    // Failed the Symbolic Link Check
    case KFSymbolic = 34859
    // Failed the File Exists Check
    case KFFileExists = 6625
}

@objc public class IRoot: NSObject {
    @objc public func isRooted() -> Bool {
        let jailbroken = self.isJailbroken()
        return jailbroken
    }
    
    func isJailbroken() -> Bool {
                
        print("1. Simulator")
        #if targetEnvironment(simulator)
            return true;
        #endif

        print("2. File Exists");
        if FileManager.default.fileExists(atPath: "/Applications/Cydia.app") {
            return true
        } else if FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") {
            return true
        } else if FileManager.default.fileExists(atPath: "/bin/bash") {
            return true
        } else if FileManager.default.fileExists(atPath: "/usr/sbin/sshd") {
            return true
        } else if FileManager.default.fileExists(atPath: "/etc/apt") {
            return true
        }
        
        print("3. File Paths")
        let filePaths = [
            "/bin/bash",
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/private/var/stash",
            "/private/var/lib/apt",
            "/private/var/tmp/cydia.log",
            "/private/var/lib/cydia",
            "/private/var/mobile/Library/SBSettings/Themes",
            "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
            "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
            "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
            "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
            "/var/cache/apt",
            "/var/lib/cydia",
            "/var/log/syslog",
            "/var/tmp/cydia.log",
            "/bin/sh",
            "/usr/libexec/ssh-keysign",
            "/usr/bin/sshd",
            "/usr/libexec/sftp-server",
            "/etc/ssh/sshd_config",
            "/Applications/RockApp.app",
            "/Applications/Icy.app",
            "/Applications/WinterBoard.app",
            "/Applications/SBSettings.app",
            "/Applications/MxTube.app",
            "/Applications/IntelliScreen.app",
            "/Applications/FakeCarrier.app",
            "/Applications/blackra1n.app",
            "/usr/bin/frida-server",
            "/usr/local/bin/cycript",
            "/usr/lib/libcycript.dylib",
            "/private/var/tmp/palera1n",
            "/cores/binpack/Applications/palera1nLoader.app"
        ]
        
        var fileOpened = false
        
        for path in filePaths {
            if self.canOpenFile(at: path) {
                print("Successfully opened file at path: \(path)")
                fileOpened = true
                break
            }
        }
        
        if fileOpened {
            return true;
        }
        
        print("4. Write file in system path")
        let testWriteText = "Jailbreak test"
        let testWritePath = "/private/jailbreaktest.txt"
        
        do {
            try testWriteText.write(toFile: testWritePath, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: testWritePath)
            return true
        } catch {
            try? FileManager.default.removeItem(atPath: testWritePath)
        }
        
        print("5. Open URL with Cydia scheme")
        if UIApplication.shared.canOpenURL(URL(string: "cydia://package/com.example.package")!) {
            return true
        }
        
        print("6. Symbolic Link Verification")
        var s = stat()

        if lstat("/Applications", &s) != 0 ||
            lstat("/var/stash/Library/Ringtones", &s) != 0 ||
            lstat("/var/stash/Library/Wallpaper", &s) != 0 ||
            lstat("/var/stash/usr/include", &s) != 0 ||
            lstat("/var/stash/usr/libexec", &s) != 0 ||
            lstat("/var/stash/usr/share", &s) != 0 ||
            lstat("/var/stash/usr/arm-apple-darwin9", &s) != 0 {
            if (s.st_mode & mode_t(S_IFMT)) == S_IFLNK {
                    return true
            }
        }

        print("7. Static Jailbreak Checks")
        // Make an int to monitor how many checks are failed
        var motzart: Int = 0

        // URL Check
        if urlCheck() != NOTJAIL {
            // Jailbroken
            motzart += 3
        }

        // Cydia Check
        if cydiaCheck() != NOTJAIL {
            // Jailbroken
            motzart += 3
        }
        
        // Inaccessible Files Check
        if inaccessibleFilesCheck() != NOTJAIL {
            // Jailbroken
            motzart += 3;
        }

        // Plist Check
        if plistCheck() != NOTJAIL {
            // Jailbroken
            motzart += 2;
        }

        // Processes Check
        if processesCheck() != NOTJAIL {
            // Jailbroken
            motzart += 2;
        }
        
        // FSTab Check
        if fstabCheck() != NOTJAIL {
            // Jailbroken
            motzart += 1;
        }

        // Shell Check
        if systemCheck() != NOTJAIL {
            // Jailbroken
            motzart += 2;
        }

        // Symbolic Link Check
        if symbolicLinkCheck() != NOTJAIL {
            // Jailbroken
            motzart += 2;
        }

        // FilesExist Integrity Check
        if filesExistCheck() != NOTJAIL {
            // Jailbroken
            motzart += 2;
        }

        // Check if the Jailbreak Integer is 3 or more
        if (motzart >= 3) {
            // Jailbroken
            return true;
        }

        return false;
    }
            
    func canOpenFile(at path: String) -> Bool {
        let file = fopen(path, "r")
        if file != nil {
            fclose(file)
            return true
        }
        return false
    }
    
    // UIApplication CanOpenURL Check
    func urlCheck() -> Int {
        // Create a fake url for Cydia
        guard let fakeURL = URL(string: CYDIAPACKAGE) else {
            return NOTJAIL
        }
        // Return whether or not Cydia's openurl item exists
        if UIApplication.shared.canOpenURL(fakeURL) {
            return JailbrokenChecks.KFOpenURL.rawValue
        } else {
            return NOTJAIL
        }
    }
    
    // Cydia Check
    func cydiaCheck() -> Int {
        // Create a file path string
        let filePath = CYDIALOC
        // Check if it exists
        if FileManager.default.fileExists(atPath: filePath) {
            // It exists
            return JailbrokenChecks.KFCydia.rawValue
        } else {
            // It doesn't exist
            return NOTJAIL
        }
    }
    
    // Inaccessible Files Check
    func inaccessibleFilesCheck() -> Int {
        // Run through the array of files
        for key in HIDDENFILES {
            // Check if any of the files exist (should return no)
            if FileManager.default.fileExists(atPath: key) {
                // Jailbroken
                return JailbrokenChecks.KFIFC.rawValue
            }
        }

        // Shouldn't get this far, return not jailbroken
        return NOTJAIL
    }
    
    // Plist Check
    func plistCheck() -> Int {
        let EXEPATH = Bundle.main.executablePath
        let PLISTPATH = Bundle.main.infoDictionary

        let FILECHECK = { (path: String) in
            return FileManager.default.fileExists(atPath: path)
        }

        // Define the Executable name
        let ExeName = EXEPATH
        let ipl = PLISTPATH

        // Check if the plist exists
        if !FILECHECK(ExeName ?? "") || ipl == nil || (ipl?.count ?? 0) <= 0 {
            // Executable file can't be found and the plist can't be found...hmmm
            return JailbrokenChecks.KFPlist.rawValue
        } else {
            // Everything is good
            return NOTJAIL
        }
    }
    
    // Running Processes Check
    func processesCheck() -> Int {
        // Make a processes array
        if let processes = runningProcesses() {
            // Check for Cydia in the running processes
            for dict in processes {
                // Define the process name
                guard let process = dict["ProcessName"] as? String else {
                    continue
                }
                // If the process is this executable
                if process == CYDIA {
                    // Return Jailbroken
                    return JailbrokenChecks.KFProcessesCydia.rawValue
                } else if process == OTHERCYDIA {
                    // Return Jailbroken
                    return JailbrokenChecks.KFProcessesOtherCydia.rawValue
                } else if process == OOCYDIA {
                    // Return Jailbroken
                    return JailbrokenChecks.KFProcessesOtherOCydia.rawValue
                }
            }

            // Not Jailbroken
            return NOTJAIL

        } else {
            return NOTJAIL
        }
    }
    
    // Get the running processes
    func runningProcesses() -> [[String: Any]]? {
        // Define the int array of the kernel's processes
        var mib = [CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0]
        let miblen: u_int = u_int(mib.count)


        // Make a new size and int of the sysctl calls
        var size: size_t = 0
        var st = sysctl(&mib, miblen, nil, &size, nil, 0)


        // Make new structs for the processes
        var process: UnsafeMutablePointer<kinfo_proc>? = nil
        var newprocess: UnsafeMutablePointer<kinfo_proc>? = nil

        // Do get all the processes while there are no errors
        repeat {
            // Add to the size
            size += size / 10
            // Get the new process
            newprocess = process?.withMemoryRebound(to: kinfo_proc.self, capacity: 1) { ptr in
                // Cast the result of realloc to the expected type
                let newPtr = realloc(ptr, size).bindMemory(to: kinfo_proc.self, capacity: 1)
                return newPtr
            }
            
            // If the process selected doesn't exist
            if newprocess == nil {
                // But the process exists
                if process != nil {
                    // Free the process
                    free(process)
                }
                // Return that nothing happened
                return nil
            }
            // Make the process equal
            process = newprocess

            // Set the st to the next process
            st = sysctl(&mib, miblen, process, &size, nil, 0)
        } while st == -1 && errno == ENOMEM

        // As long as the process list is empty
        if st == 0 {
            // And the size of the processes is 0
            if size % MemoryLayout<kinfo_proc>.stride == 0 {
                // Define the new process
                let nprocess = Int(size / MemoryLayout<kinfo_proc>.stride)
                // If the process exists
                if nprocess > 0 {
                    // Create a new array
                    var array = [[String: Any]]()
                    // Run through a for loop of the processes
                    for i in (0..<nprocess).reversed() {
                        // Get the process ID
                        let processID = String(format: "%d", process![i].kp_proc.p_pid)
                        // Get the process Name
                        let processName = String(cString: &process![i].kp_proc.p_comm.0, encoding: .utf8)
                        // Get the process Priority
                        let processPriority = String(format: "%d", process![i].kp_proc.p_priority)
                        // Get the process running time
                        let processStartDate = Date(timeIntervalSince1970: TimeInterval(process![i].kp_proc.p_un.__p_starttime.tv_sec))
                        // Create a new dictionary containing all the process ID's and Name's
                        let dict: [String: Any] = ["ProcessID": processID,
                                                    "ProcessPriority": processPriority,
                                                   "ProcessName": processName!,
                                                    "ProcessStartDate": processStartDate]
                        // Add the dictionary to the array
                        array.append(dict)
                    }
                    // Free the process array
                    free(process)

                    // Return the process array
                    return array
                }
            }
        }

        // If no processes are found, return nothing
        return nil
    }
    
    func fstabCheck() -> Int {
        do {
            let fileManager = FileManager.default
            let attributes = try fileManager.attributesOfItem(atPath: "/etc/fstab")
            if let size = attributes[.size] as? Int64, size == 80 {
                // Not jailbroken
                return NOTJAIL
            } else {
                // Jailbroken
                return JailbrokenChecks.KFFSTab.rawValue
            }
        } catch {
            // Not jailbroken
            return NOTJAIL
        }
    }
    
    func systemCheck() -> Int {
        // See if the system call can be used
        /*if system(nil) != -1 {
            // System call available
         return JailbrokenChecks.KFSystem.rawValue
         } else */
            // System call not available
            return NOTJAIL
    }
    
    func symbolicLinkCheck() -> Int {
        do {
            // See if the Applications folder is a symbolic link
            let fileManager = FileManager.default
            let attributes = try fileManager.attributesOfItem(atPath: "/Applications")
            
            if let fileType = attributes[.type] as? FileAttributeType,
               fileType == .typeSymbolicLink {
                // Device is jailbroken
                return JailbrokenChecks.KFSymbolic.rawValue
            } else {
                // Not jailbroken
                return NOTJAIL
            }
        } catch {
            // Not Jailbroken
            return NOTJAIL
        }
    }
    
    func filesExistCheck() -> Int {
        let fileManager = FileManager.default
        // Check if filemanager is working
        if !fileManager.fileExists(atPath: Bundle.main.executablePath!) {
            // Jailbroken and trying to hide it
            return JailbrokenChecks.KFFileExists.rawValue
        } else {
            // Not Jailbroken
            return NOTJAIL
        }
    }
    
}
