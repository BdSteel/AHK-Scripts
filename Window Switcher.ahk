#ErrorStdOut
!`::
{
    ;OutputDebug 'cmd+`` `n'
    changeActiveWindow("forward")
}

<+!`::
{
    ;OutputDebug 'cmd+shift+`` `n'
    changeActiveWindow("back")
}

changeActiveWindow(dir)
{
    static windowOrder := []
    static expectedOrder := []
    currentOrder := []
    CatchWindowsExplorerErrors := true ; Windows Explorer creates a number of invisible windows which breaks behavior when using the alt menu. Set this to false to let these errors through.
    debugging := false

    ; Get all windows the same as the active window
    OldClass := WinGetClass("A")
    ActiveProcessName := WinGetProcessName("A")
    WinClassCount := WinGetCount("ahk_exe " ActiveProcessName)
    ActiveId := WinGetID("A")
    OutputDebug 'Current Window:    ' ActiveId '/' OldClass '/' ActiveProcessName '/' WinGetTitle("ahk_id" ActiveId) '`n'
    
    ; If there's only one window, do nothing
    if (WinClassCount = 1)
        Return

    ; Get all windows of the same process
    ids := WinGetList("ahk_exe " ActiveProcessName)
    for SiblingID in ids {
        if (WinGetTitle(SiblingID) != ""){
            if (CatchWindowsExplorerErrors){
                if ( WinGetClass(SiblingID) != "KbxLabelClass" && WinGetTitle(SiblingID) != "Program Manager"){
                    currentOrder.Push(SiblingID)
                }
            } else {
                currentOrder.Push(SiblingID)
            }
        }
    }

    ; Check first run and populate
    if windowOrder.Length = 0 {
        resetWindows()
    }
    printDebugging()

    ; Check if current order and length match expected order and length
    ; If they don't, expected order has changed or a window has been removed or inserted
    if (currentOrder.Length = expectedOrder.Length) {
        Loop currentOrder.Length {
            if (currentOrder[A_Index] != expectedOrder[A_Index]){
                resetWindows()
                break
            }
        }
    } else {
        resetWindows()
    }

    windowOrder := moveToNextIndex(windowOrder, dir)
    changeActiveWindow()
    expectedOrder := updateExpectedOrder(expectedOrder, windowOrder)
    printDebugging()

    OutputDebug '`n'


    ; Functions
    ; Reset the windows to the current state - used if the order doesn't match the expected order e.g. a new window is introduced or the user has clicked and changed order
    resetWindows(){
        OutputDebug 'Restting memory`n'
        windowOrder := currentOrder.Clone()
        expectedOrder := currentOrder.Clone()
        return
    }

    ; Used to update the active window tracked by windowOrder
    changeActiveWindow(){
        WinActivate("ahk_id" windowOrder[1])
        try {
            OutputDebug 'Switching to:    ' WinGetTitle("ahk_id" windowOrder[1]) ' -- ' windowOrder[1] '`n'
        } catch Error as e {
            OutputDebug "An error was thrown!`nSpecifically: " e.Message
            Exit
        }
    }

    ; Print debugging information
    printDebugging(){
        if (debugging){
            OutputDebug '---------------------- currentOrder: ----------------------`n'
            for e in currentOrder {
                OutputDebug WinGetTitle("ahk_id" e) ' -- ' e '`n'
            }
            OutputDebug '---------------------- windowOrder: ----------------------`n'
            for e in windowOrder {
                OutputDebug WinGetTitle("ahk_id" e) ' -- ' e '`n'
            }
            OutputDebug '---------------------- expectedOrder: ----------------------`n'
            for e in expectedOrder {
                OutputDebug WinGetTitle("ahk_id" e) ' -- ' e '`n'
            }
        }
    }
}



getArrayValueIndex(arr, val){
    Loop arr.Length {
        if (arr[A_Index] == val)
			return A_Index
    }
}

moveToNextIndex(arr, dir){
    if (dir == "forward"){
        e := arr[1]
        arr.RemoveAt(1)
        arr.Push(e)
        return arr
    } else if (dir == "back"){
        e := arr[arr.Length]
        arr.RemoveAt(arr.Length)
        arr.InsertAt(1, e)
        return arr
    }
}

moveLastIndexToFirst(arr){
    e := arr[1]
    arr.RemoveAt(1)
    arr.Push(e)
    return arr
}

updateExpectedOrder(eo, wo){
    activeWindowIndex := getArrayValueIndex(eo, wo[1])
    activeWindow := eo[activeWindowIndex]
    eo.RemoveAt(activeWindowIndex)
    eo.InsertAt(1, activeWindow)
    return eo
}
