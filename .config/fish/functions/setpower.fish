# Might delete this in the future, not sure that it does a whole lot.
function setpower
    switch $argv[1]
        case saver
            powerprofilesctl set power-saver
            sudo nvidia-smi -pl 30 > /dev/null
        case normal
            powerprofilesctl set balanced
            sudo nvidia-smi -pl 30 > /dev/null
        case perf
            powerprofilesctl set performance
            sudo nvidia-smi -pl 50 > /dev/null
        case '*'
            echo "Usage: setpower [saver|normal|perf]"
    end
end
