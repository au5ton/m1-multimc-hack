####################
# DownloadLatestLWJGLNatives
####################

### HELPER FUNCS AND CONSTANTS

# saves POSIX path of this directory where this script is located
set cwd to POSIX path of ((path to me as text) & "::")

# runs a shell command at the provided directory
to shell(command, dir)
	do shell script "cd " & (quoted form of POSIX path of dir) & "; " & command
end shell

# download a file to the provided directory using cURL
to download(link, dir)
	shell("curl -L -O " & link, dir)
end download

### UPDATE NATIVES

# set some shorthand names for the location of natives
set nativesUrlPrefix to "https://build.lwjgl.org/nightly/macosx/arm64/"
set nativesFolder to (cwd & "/lwjglnatives")
# get a list of every file in lwjglnatives
set dylibFiles to every paragraph of shell("ls -1", nativesFolder)

# update some reserved variables to display a progress bar
set progress total steps to length of dylibFiles
set progress completed steps to 0
set progress description to "Downloading LWJGL3 nightly dylibs..."
set progress additional description to "Preparing to process."

# iterate over every dylib we have and grab the latest version
repeat with i from 1 to length of dylibFiles
	set dllName to item i of dylibFiles
	set progress additional description to "Updating: " & nativesUrlPrefix & dllName
	# url pattern:
	# https://build.lwjgl.org/nightly/macosx/arm64/liblwjgl.dylib
	download(nativesUrlPrefix & dllName, nativesFolder)
	set progress completed steps to i
end repeat

### UPDATE JARS

# set some shorthand names for the location of jars
set jarsUrlPrefix to "https://build.lwjgl.org/nightly/bin/"
set jarsFolder to (cwd & "/lwjglclasspath")
# get a list of every file in lwjglnatives
set jarFiles to every paragraph of shell("ls -1", jarsFolder)

# update some reserved variables to display a progress bar
set progress total steps to length of jarFiles
set progress completed steps to 0
set progress description to "Downloading LWJGL3 nightly jars..."
set progress additional description to "Preparing to process."

# iterate over every jar we have and grab the latest version
repeat with i from 1 to length of jarFiles
	set binName to item i of jarFiles
	set baseName to do shell script "basename " & binName & " .jar"
	set progress additional description to "Updating: " & jarsUrlPrefix & binName
	# url pattern:
	# https://build.lwjgl.org/nightly/bin/lwjgl-opengl/lwjgl-opengl.jar
	download(jarsUrlPrefix & baseName & "/" & binName, jarsFolder)
	set progress completed steps to i
end repeat

### END
display dialog "LWJGL3 natives and jars were updated."
