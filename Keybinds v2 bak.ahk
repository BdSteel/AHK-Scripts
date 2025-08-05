!`::
{
    OutputDebug '`n------------------------`n'

    static LastRun := 0
    static QuickPress := 0
    static triggerCount := 0
    static windowOrder := []
    static expectedActivity := []
    currentWindows := []

    ; Only execute every x milisecond -- can probably remove?
    ;Now := A_TickCount
    ;if (Now - LastRun < 0)
    ;    QuickPress++
    ;else
    ;    QuickPress := 0

    ;windowOrder.Push('sdfjklsdf')
    ;for e in windowOrder {
    ;    OutputDebug 'length: ' windowOrder.Length ' ' e. '`n'
    ;}

    triggerCount += 1
    OutputDebug 'triggerCount: ' triggerCount '`n'
    ;OutputDebug 'Now: ' Now ' LastRun: ' LastRun ' QuickPress: ' QuickPress '`n'

    ; Get all windows the same as the active window
    OldClass := WinGetClass("A")
    ActiveProcessName := WinGetProcessName("A")
    WinClassCount := WinGetCount("ahk_exe " ActiveProcessName)
    ActiveId := WinGetID("A")
    OutputDebug 'Current:    ' ActiveId '/' OldClass '/' ActiveProcessName '/' WinGetTitle("ahk_id" ActiveId) "`n"
    
    ; If there's only one window, do nothing
    if (WinClassCount = 1)
        Return

    ;ToSkip := QuickPress
    ;OutputDebug 'Will skip ' ToSkip ' of ' WinClassCount '`n'

    ids := WinGetList("ahk_exe " ActiveProcessName)
    for SiblingID in ids {
        if WinGetTitle(SiblingID) != "" {
            currentWindows.Push(SiblingID)
        }
        if (WinGetClass("ahk_id" SiblingID) != OldClass)
            continue

        ;OutputDebug 'Found:      ' SiblingID '/' WinGetClass("ahk_id" SiblingID) '/' WinGetProcessName("ahk_id" SiblingID) '/' WinGetTitle("ahk_id" SiblingID) '`n'

        ;if (SiblingID != ActiveId) {
        ;    OutputDebug 'Switch to:  ' SiblingID '/' WinGetClass("ahk_id" SiblingID) '/' WinGetProcessName("ahk_id" SiblingID) '/' WinGetTitle("ahk_id" SiblingID) '`n'
        ;    WinActivate("ahk_id" SiblingID)
        ;    break
        ;}
    }

    if windowOrder.Length = 0 {
        windowOrder := currentWindows
    }

    OutputDebug '--- currentWindows: `n'
    for e in currentWindows {
        OutputDebug WinGetTitle("ahk_id" e) ' -- ' e '`n'
    }

    OutputDebug '--- windows:`n'
    for e in windowOrder {
        OutputDebug WinGetTitle("ahk_id" e) ' -- ' e '`n'
    }
    for e in windowOrder {
        OutputDebug WinGetTitle("ahk_id" e) ' -- ' e '`n'
        OutputDebug getArrayValueIndex(windowOrder, e) '`n'
        if e == WinGetID("A") {
            OutputDebug getArrayValueIndex(windowOrder, e) '`n'
            WinActivate("ahk_id" windowOrder[getArrayValueIndex(windowOrder, e) + 1])
            ;WinActivate("ahk_id" windowOrder[2])
            break
        }
    }
    LastRun := A_TickCount
}

getArrayValueIndex(arr, val) {
	Loop arr.Length {
		if (arr[A_Index] == val)
			return A_Index
	}
}

;TODO check if window is in alt mode? Seems to break