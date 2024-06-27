Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = 'イベント処理のデモ'
$form.Size = New-Object System.Drawing.Size(300,200)

$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(100,70)
$button.Size = New-Object System.Drawing.Size(100,23)
$button.Text = 'ホバーしてください'

# マウスエンターイベントの処理
$button.Add_MouseEnter({
    $button.Text = 'マウスが上にあります'
})

# マウスが離れたときのテキストを元に戻す
$button.Add_MouseLeave({
    $button.Text = 'ホバーしてください'
})

# フォームのクローズイベントの処理
$form.Add_FormClosing({
    [System.Windows.Forms.MessageBox]::Show('フォームが閉じられます')
})

$form.Controls.Add($button)
$form.ShowDialog()