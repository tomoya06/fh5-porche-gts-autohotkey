SetKeyDelay, 300

loopTime := 10

ShowTrayTip("我好了 请高亮FH5游戏窗口 按Ctrl+Shift+Home开始")


; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
; Ctrl + Shift + T 测试一个脚本
^+T::
; GotoPorsche()
; GotoOneGtsCar()
; EnterGarage()

UpgradeOneGTS()
DeleteOneGtsCar()

ShowTrayTip("测试完了")
Return


; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
; Ctrl + Shift + B 在车辆收藏里多次购买车辆
^+B::
Loop, %loopTime% {
  BuyOneGtsCarInCollection()
}

ShowTrayTip("买了" . loopTime . "次", 1000)
Return


; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
; Ctrl + Shift + Home 开始批量升级
^+Home::
ShowTrayTip("即将开始" . loopTime . "次升级", 2000)

Loop, %loopTime% {
  DriveOneNewGTS()
  UpgradeOneGTS()
  DeleteOneGtsCar()
  ShowTrayTip("搞定了第" . A_Index . "次", 1000)
}

ShowTrayTip("好了")
Return


; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
; Ctrl + Shift + PgUp 升级当前的新GTS
^+PgUp::

UpgradeOneGTS()
DeleteOneGtsCar()

ShowTrayTip("升级完了")
Return


; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
; Ctrl + Shift + C 获取鼠标位置和颜色
^+C::
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
DriveOneNewGTS() {
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
  SetKeyDelay 100
  Send {Left}
  Send {Enter}

  WaitTillColorMatch(258, 253, 0xFFDE39)
  Send {Right 2}
  Send {Down}
  Send {Enter}
  WaitTillColorMatch(646, 226, 0xFFDE39)

  SetKeyDelay 300
  ClickGTSTree()

  ; 回到升级套件页面
  Send {Esc}
  WaitTillColorMatch(258, 253, 0xFFDE39)
  ; 回到主页面
  Send {Esc}
  WaitTillHomePage()
}


; 删除一辆旧车
DeleteOneGtsCar() {
  ResetHomePage()
  EnterGarage()
  GotoPorsche()
  GotoOneGtsCar()

  Send {Enter}
  WaitTillColorMatch(1242, 424, 0x341735)
  SetKeyDelay 100
  Send {Down 4}
  Send {Enter}
  SetKeyDelay 300

  WaitTillColorMatch(1139, 500, 0x341735)
  Send {Enter}

  Sleep 1000
  Send {Esc}
  WaitTillHomePage()
}

; ================================================
; 基本动作
; ================================================

; 在车辆收藏里买一辆GTS
BuyOneGtsCarInCollection() {
  Send {Y}
  WaitTillColorMatch(1144, 458, 0x341735)
  Send {Enter}
  Sleep 500
}

; 嘉年华界面恢复到初始位
ResetHomePage() {
  Send {PgUp}
  Send {PgDn}
}

; 进入车库&等待结束
EnterGarage() {
  Send {Enter}
  WaitTillColorMatch(429, 181, 0xFFDE39)
}

; 选中车厂&等待结束
GotoPorsche() {
  Send {BackSpace}
  Sleep 500
  SetKeyDelay 50
  Send {Left 1}
  Send {Down 11}
  Send {Enter}
  Sleep 500
  SetKeyDelay 300
}

; 定位到第一辆GTS车辆&等待结束
GotoOneGtsCar() {
  SetKeyDelay, 100
  Send {Right 5}
  Send {Down 1}
  Sleep, 1000
  SetKeyDelay, 300
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
  Sleep 2000
  WaitTillColorMatch(1769, 65, 0x000000, False)
  Sleep 500
  Send {Esc}
  WaitTillHomePage()
}

; 点一个技能块
ClickOneBlockAndWait() {
  Send {Enter}
  Sleep 1000
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


; ================================================
; 等待页面判断
; ================================================

; 返回主页 判断"设计与涂装"卡片颜色=紫色
WaitTillHomePage() {
  WaitTillColorMatch(451, 611, 0x341735)
}

; ================================================
; 辅助函数
; ================================================

; 等到颜色匹配才结束
WaitTillColorMatch(mouseX, mouseY, colorHere, flag = True) {
  Loop {
    if (flag) {
      isMatch := CheckIfColorMatch(mouseX, mouseY, colorHere)
    } else {
      isMatch := CheckIfColorNotMatch(mouseX, mouseY, colorHere)
    }
    if (isMatch) {
      Break
    }
  }
  ; 勉强再等个200ms
  Sleep 200
}

; 检查坐标颜色
CheckIfColorMatch(mouseX, mouseY, colorHere) {
  PixelGetColor, curColor, %mouseX%, %mouseY%, RGB

  return colorHere == curColor
}

; 检查坐标颜色取反
CheckIfColorNotMatch(mouseX, mouseY, colorHere) {
  PixelGetColor, curColor, %mouseX%, %mouseY%, RGB

  return colorHere != curColor
}

; 获取鼠标颜色
GetMouseColor() {
  MouseGetPos, mouseX, mouseY
  PixelGetColor, colorHere, %mouseX%, %mouseY%, RGB

  MsgBox %mouseX%, %mouseY%, %colorHere%
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