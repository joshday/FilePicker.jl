module FilePicker

export filepicker, dirpicker

#-----------------------------------------------------------------------------# Apple
module Apple
    cmd(x) = strip(read(Cmd(["osascript", "-e", "return POSIX path of ($x)"]), String))
    single_file() = cmd("choose file")
    multiple_files() = cmd("choose file with multiple selections allowed")
    single_dir() = cmd("choose folder")
    multiple_dirs() = cmd("choose folder with multiple selections allowed")
end

#-----------------------------------------------------------------------------# Linux
module Linux
    cmd(x...) = strip(read(Cmd(["zenity", "--file-selection", x...]), String))
    single_file() = cmd()
    multiple_files() = cmd("--multiple", "--separator='\n'")
    single_dir() = cmd("--directory")
    multiple_dirs() = cmd("--directory", "--multiple", "--separator='\n'")
end

#-----------------------------------------------------------------------------# Windows
module Windows
    cmd(x) = strip(read(Cmd(["powershell", "-NoProfile", "-Command", "Add-Type -AssemblyName System.Windows.Forms $x"]), String))

    single_file() = cmd("\$f = New-Object System.Windows.Forms.OpenFileDialog; if(\$f.ShowDialog() -eq 'OK'){ \$f.FileName }")
    multiple_files() = cmd("\$f = New-Object System.Windows.Forms.OpenFileDialog; \$f.Multiselect = \$true; if(\$f.ShowDialog() -eq 'OK'){ \$f.FileNames -join '\n' }")
    single_dir() = cmd("\$f = New-Object System.Windows.Forms.FolderBrowserDialog; if(\$f.ShowDialog() -eq 'OK'){ \$f.SelectedPath }")
    multiple_dirs() = error("Multiple directories not supported on Windows")
end

#-----------------------------------------------------------------------------# core functions
M = @static if Sys.isapple()
    Apple
elseif Sys.islinux()
    try
        run(`zenity --version`)
    catch
        error("Zenity is required on Linux. Please install it using 'sudo apt install zenity'")
    end
    Linux
elseif Sys.iswindows()
    Windows
else
    error("Unsupported OS")
end

filepicker(multiple=false) = multiple ? M.multiple_files() : M.single_file()
dirpicker(multiple=false) = multiple ? M.multiple_dirs() : M.single_dir()


end
