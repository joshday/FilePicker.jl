module FilePickerLight

export file, files, dir, dirs

#-----------------------------------------------------------------------------# Apple
module Apple
    osascript::String = "osascript"
    function cmd(x)
        try
            run(`which $osascript`)
        catch
            error("""
            `osascript` is part of macOS but was not found in the PATH.  Please either:

            1. Add `osascript` to the PATH.
            2. Set the `FilePickerLight.Apple.osascript::String` variable to the full path of `osascript`.
            """)
        end
        strip(read(Cmd([osascript, "-e", "return POSIX path of ($x)"]), String))
    end
    file() = cmd("choose file")
    files() = cmd("choose file with multiple selections allowed")
    dir() = cmd("choose folder")
    dirs() = cmd("choose folder with multiple selections allowed")
end

#-----------------------------------------------------------------------------# Linux
module Linux
    zenity::String = "zenity"
    kdialog::String = "kdialog"
    yad::String = "yad"

    zenity_cmd(x...) = strip(read(Cmd(["zenity", "--file-selection", x...]), String))
    zenity_file() = cmd()
    zenity_files() = cmd("--multiple", "--separator='\n'")
    zenity_dir() = cmd("--directory")
    zenity_dirs() = cmd("--directory", "--multiple", "--separator='\n'")

    kdialog_cmd(x...) = strip(read(Cmd(["kdialog", "--getopenfilename", x...]), String))
    kdialog_file() = cmd()
    kdialog_files() = cmd("--multiple")
    kdialog_dir() = cmd("--getexistingdirectory")
    kdialog_dirs() = cmd("--getexistingdirectory", "--multiple")

    yad_cmd(x...) = strip(read(Cmd(["yad", "--file-selection", x...]), String))
    yad_file() = cmd()
    yad_files() = cmd("--multiple")
    yad_dir() = cmd("--directory")
    yad_dirs() = cmd("--directory", "--multiple")

    _error() = error("""
        `zenity`, `kdialog`, or `yad` is not found in the PATH.  Please either:

        1. Add `zenity`, `kdialog`, or `yad` to the PATH.
        2. Set the `FilePickerLight.Linux.zenity::String`, `FilePickerLight.Linux.kdialog::String`, or `FilePickerLight.Linux.yad::String` variable to the full path of `zenity`, `kdialog`, or `yad`.
        """
    )

    function file()
        try; run(`which $zenity`); return zenity_file(); catch end
        try; run(`which $kdialog`); return kdialog_file(); catch end
        try; run(`which $yad`); return yad_file(); catch end
        _error()
    end
    function files()
        try; run(`which $zenity`); return zenity_files(); catch end
        try; run(`which $kdialog`); return kdialog_files(); catch end
        try; run(`which $yad`); return yad_files(); catch end
        _error()
    end
    function dir()
        try; run(`which $zenity`); return zenity_dir(); catch end
        try; run(`which $kdialog`); return kdialog_dir(); catch end
        try; run(`which $yad`); return yad_dir(); catch end
        _error()
    end
    function dirs()
        try; run(`which $zenity`); return zenity_dirs(); catch end
        try; run(`which $kdialog`); return kdialog_dirs(); catch end
        try; run(`which $yad`); return yad_dirs(); catch end
        _error()
    end
end

#-----------------------------------------------------------------------------# Windows
# On Windows, powershell is part of the OS.  It can't be uninstalled, but it may not be in the PATH.
module Windows
    powershell::String = "powershell"
    function cmd(x)
        try
            run(`which $powershell`)
        catch
            error("""
            `powershell` is part of macOS but was not found in the PATH.  Please either:

            1. Add `powershell` to the PATH.
            2. Set the `FilePickerLight.Windows.powershell::String` variable to the full path of `powershell`.
            """)
        end
        strip(read(Cmd([powershell, "-NoProfile", "-Command", "Add-Type -AssemblyName System.Windows.Forms $x"]), String))
    end

    file() = cmd("\$f = New-Object System.Windows.Forms.OpenFileDialog; if(\$f.ShowDialog() -eq 'OK'){ \$f.FileName }")
    files() = cmd("\$f = New-Object System.Windows.Forms.OpenFileDialog; \$f.Multiselect = \$true; if(\$f.ShowDialog() -eq 'OK'){ \$f.FileNames -join '\n' }")
    dir() = cmd("\$f = New-Object System.Windows.Forms.FolderBrowserDialog; if(\$f.ShowDialog() -eq 'OK'){ \$f.SelectedPath }")
    dirs() = error("Multiple directories not supported on Windows")
end

#-----------------------------------------------------------------------------# core functions
M = @static Sys.isapple() ? Apple : Sys.islinux() ? Linux : Windows

file() = M.file()
files() = M.files()
dir() = M.dir()
dirs() = M.dirs()


end
