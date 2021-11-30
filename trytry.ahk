SetKeyDelay, 300

loopTime := 5


^Home::
Return

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
^+B::
Loop, %loopTime% {
  BuyOneGtsCarInCollection()
}

ShowTrayTip("买了" . loopTime . "次", 1000)
Return

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
!Home::

Loop, %loopTime% {
  DriveOneGTS()
  UpgradeOneGTS()
  DeleteOneGtsCar()
  ShowTrayTip("买了第" . A_Index . "次", 1000)
}

ShowTrayTip("好了")
Return


; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
!End::
GetMouseColor()
Return



; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
; Ctrl + Shift + Delete 重启脚本&叫停
^+Delete::
Reload
Return


; ================================================
; --串联动作-- 
; ================================================

; 选中一辆新的GTS
DriveOneGTS() {
  ResetHomePage()
  EnterGarage()
  GotoPorsche()
  Sleep 1000
  DriveOneGtsCar()
  
  WaitNewCarAnime()
}

; 升级一辆GTS
UpgradeOneGTS() {
  ResetHomePage()
  Send {Left}
  Send {Enter}
  Send {Right 3}
  Send {Down}
  Send {Enter}

  Sleep 2000
  ClickGTSTree()

  Send {Esc}
  Sleep 2000
  Send {Esc}
  Sleep 2000
}


; 删除一辆旧车
DeleteOneGtsCar() {
  ResetHomePage()
  EnterGarage()
  GotoPorsche()
  GotoOneGtsCar()

  Send {Enter}
  Sleep 1000
  Send {Down 4}
  Send {Enter}

  Sleep 1000
  Send {Enter}

  Sleep 1000
  Send {Esc}
  Sleep 3000
}

; ================================================
; 基本动作
; ================================================

; 在车辆收藏里买一辆GTS
BuyOneGtsCarInCollection() {
  Send {Y}
  Sleep 1000
  Send {Enter}
  Sleep 1000
}

; 嘉年华界面恢复到初始位
ResetHomePage() {
  Send {PgUp}
  Send {PgDn}
}

; 进入车库&等待结束
EnterGarage() {
  ResetHomePage()

  Send {Enter}
  Sleep 3000
}

; 选中车厂&等待结束
GotoPorsche() {
  Send {BackSpace}
  Sleep 500
  Send {Left 1}
  Send {Down 11}
  Send {Enter}
  Sleep 1000
}

; 定位到第一辆GTS车辆&等待结束
GotoOneGtsCar() {
  Send {Right 5}
  Send {Down 1}
  Sleep, 1000
}

; 定位并坐上第一辆GTS车型&等待结束
DriveOneGtsCar() {
  GotoOneGtsCar()
  Send {Enter}
  Send {Enter}

  Sleep 1000
}

; 等待新车动画&返回首页
WaitNewCarAnime() {
  Sleep, 8000
  Send {Esc}
  Sleep 3000
}

; 点一个技能块
ClickOneBlockAndWait() {
  Send {Enter}
  Sleep 1500
}

; 点GTS的技能树
ClickGTSTree() {
  ClickOneBlockAndWait()
  Send {Right}
  ClickOneBlockAndWait()
  Send {Right}
  ClickOneBlockAndWait()
  Send {Up}
  ClickOneBlockAndWait()
  Send {Right}
  ClickOneBlockAndWait()
  Send {Left}
  Send {Up}
  ClickOneBlockAndWait()
}

; 获取鼠标颜色
GetMouseColor() {
  MouseGetPos, mouseX, mouseY
  PixelGetColor, colorHere, %mouseX%, %mouseY%, RGB

  MsgBox Pos: %mouseX% - %mouseY% Color: %colorHere%.
}

; 显示一个通知
ShowTrayTip(msg, closeDelay = 3000) {
  TrayTip 通知！, %msg%
  Sleep %closeDelay%
  HideTrayTip()
}

; 隐藏通知将此函数复制到脚本中使用.
HideTrayTip() {
  TrayTip  ; 尝试以正常的方式隐藏它.
  if SubStr(A_OSVersion,1,3) = "10." {
    Menu Tray, NoIcon
    Sleep 200  ; 可能有必要调整 sleep 的时间.
    Menu Tray, Icon
  }
}