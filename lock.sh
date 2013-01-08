#!/bin/bash

displays=""
while read id
do
    displays="$displays $id"
done< <(xvinfo | sed -n 's/^screen #\([0-9]\+\)$/\1/p')

checkFullscreen()
{
    # loop through every display looking for a fullscreen window
    for display in $displays
    do
        #get id of active window and clean output
        activ_win_id=`DISPLAY=:0.${display} xprop -root _NET_ACTIVE_WINDOW`
        #activ_win_id=${activ_win_id#*# } #gives error if xprop returns extra ", 0x0" (happens on some distros)
        activ_win_id=${activ_win_id:40:9}

echo $activ_win_id

        # Skip invalid window ids (commented as I could not reproduce a case
        # where invalid id was returned, plus if id invalid
        # isActivWinFullscreen will fail anyway.)
        #if [ "$activ_win_id" = "0x0" ]; then
        #     continue
        #fi
        
        # Check if Active Window (the foremost window) is in fullscreen state
        isActivWinFullscreen=`DISPLAY=:0.${display} xprop -id $activ_win_id _NET_WM_STATE | grep _NET_WM_STATE_FULLSCREEN`
            if [[ "$isActivWinFullscreen" = *NET_WM_STATE_FULLSCREEN* ]];then
                #isAppRunning
                #var=$?
                #if [[ $var -eq 1 ]];then
                    f_xtrlock
                #fi
            fi
echo "checkFullscreen()"
    done
}

f_xtrlock()
{

    #xtrlock

    #Check if DPMS is on. If it is, deactivate and reactivate again. If it is not, do nothing.    
    dpmsStatus=`xset -q | grep -ce 'DPMS is Enabled'`
    if [ $dpmsStatus == 1 ];then
        	xset -dpms &
          xset s noblank &
          xset s off &
    fi

exit 0
	
}

checkFullscreen
xset +dpms
xset s blank
xset s on
xset dpms force off
slock
exit 0    
