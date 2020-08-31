import subprocess


def RakuCommand(command, moduleName, rakuLocation="/Applications/Rakudo/bin/raku"):
    res = subprocess.run([rakuLocation, "-M", moduleName, "-e", command], capture_output=True)
    res.stderr = res.stderr.decode()
    res.stdout = res.stdout.decode()
    return res
