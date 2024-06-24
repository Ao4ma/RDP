# 出力エンコーディングをUTF-8に設定
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

try {
    # コンピュータの配列を定義
    $computers = @(
        @{Name="ycsvm103"; User="ycsvm103\administrator"; Password="#YamadaVM03"; Type="Server"},
        @{Name="Server2"; User="ServerUser2"; Password="ServerPassword2"; Type="Server"},
        @{Name="Server3"; User="ServerUser3"; Password="ServerPassword3"; Type="Server"},
        @{Name="delld022"; User="ygijutubu"; Password="YCg-7741315-4"; Type="LicensePC"},
        @{Name="LicensePC2"; User="LicensePCUser2"; Password="LicensePCPassword2"; Type="LicensePC"},
        @{Name="LicensePC3"; User="LicensePCUser3"; Password="LicensePCPassword3"; Type="LicensePC"}
    )

    # ClientPCクラスの定義
    class ClientPC {
        [string] $Type
        [array] $AccessibleComputers

        ClientPC([string] $type, [array] $computers) {
            $this.Type = $type
            if ($type -eq "Admin") {
                $this.AccessibleComputers = $computers
            } else {
                $this.AccessibleComputers = $computers | Where-Object {$_.Type -eq "LicensePC"}
            }
        }
    }

    # ClientPCクラスのインスタンスを作成
    $adminPC = [ClientPC]::new("Admin", $computers)

    # 選択したコンピュータ名の変数
    $selectedComputerName = "ycsvm103"

    # アクセス可能なコンピュータから選択したコンピュータを取得
    $selectedComputer = $adminPC.AccessibleComputers | Where-Object {$_.Name -eq $selectedComputerName}

    # 選択したコンピュータをファイルに保存
    $selectedComputer | Out-File -FilePath 'output.txt' -Encoding 'UTF8'

    # 自己署名証明書を作成
    $cert = New-SelfSignedCertificate -DnsName "localhost" -CertStoreLocation "cert:\CurrentUser\My" -KeyUsage DigitalSignature -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.3")
    # ファイルパスを自動で取得
    $scriptFilePath = $MyInvocation.MyCommand.Path

    # スクリプトにデジタル署名を付ける
    Set-AuthenticodeSignature -FilePath $scriptFilePath -Certificate $cert

    # Computerクラスの定義
    class Computer {
        [string] CheckRdpSession() {
            return "RDPセッションのチェック中..."
        }

        [string] GetSessionList() {
            return "セッションリストの取得中..."
        }
    }

    # Serverクラスの定義
    class Server : Computer {
        # Serverクラス固有のプロパティやメソッドをここに追加できます
    }

    # LicensePCクラスの定義
    class LicensePC : Computer {
        # LicensePCクラス固有のプロパティやメソッドをここに追加できます
    }

    # 選択したコンピュータのタイプに基づいて適切なコンピュータクラスのインスタンスを作成
    if ($selectedComputer.Type -eq "Server") {
        $computer = [Server]::new()
    } else {
        $computer = [LicensePC]::new()
    }

    # コンピュータオブジェクトのメソッドを呼び出す
    $computer.CheckRdpSession()
    $computer.GetSessionList()
}
catch {
    Write-Host "An error occurred: $_"
}
# SIG # Begin signature block
# MIIFcQYJKoZIhvcNAQcCoIIFYjCCBV4CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUh1jtftkK3jwqRISULZvWfFOn
# kkagggMSMIIDDjCCAfagAwIBAgIQHW9D+25qhqhPD+8Vp/j19zANBgkqhkiG9w0B
# AQsFADAUMRIwEAYDVQQDDAlsb2NhbGhvc3QwHhcNMjQwNjI0MDA0NDQ0WhcNMjUw
# NjI0MDEwNDQ0WjAUMRIwEAYDVQQDDAlsb2NhbGhvc3QwggEiMA0GCSqGSIb3DQEB
# AQUAA4IBDwAwggEKAoIBAQDKTHEfhFz4pGc5/B8NfD+AgoOUCH+yhX81Z9GPh7R0
# t8okNcArDgQuUNjfjahbcKD2/PpzhtU8+Mue4wtuNxgqvDNCjX2+Cq0Yt5UWQFZ/
# QXb8+lJdaY4ibZEeWXxAkdIgxUKhMAjwkj7XuAZUAsIBqN13uAOqsrgr+nSeqPMT
# JScBYZ4Jao55ZEzdctd+Xm5ZsvEFzfvl7DdzPd/Y1la6zcEIHMutO2D5yHV8PlYV
# zNOhRzJvn5iJqMlGQ+AkBQU1nd0ODPv5Cij+Gz0ec5c3kbQf3OBpfNDasKTbLfBt
# kuBDPL44KUhw7HpeEql4+cFp9/kl8558Bcu4ypbQf4oFAgMBAAGjXDBaMA4GA1Ud
# DwEB/wQEAwIHgDAUBgNVHREEDTALgglsb2NhbGhvc3QwEwYDVR0lBAwwCgYIKwYB
# BQUHAwMwHQYDVR0OBBYEFCJmf9wc4J277tUsV/DU7UnX00mkMA0GCSqGSIb3DQEB
# CwUAA4IBAQCV8P29c25x+eGbt40BWRPWjvW5JnOVh8dWv6l/gvO++OoDkI3nYlGd
# 6QOTEm3r7S7DuGW/eUp4iUo2bHb9wNauiHz6LTPJtNLV39n8/uz/Y+xqClZrpoYB
# G8ns0Qt+Mtmjqg0vQ/FX1cI1idl4ux/UZiA9tbD8F1WNeQoK2uxqudfHLfjkvjUM
# orsu+8LBp0RNNh2vBv6Lz4RFXDTI+RD5NKz1H3n4kGnjQkdA1p5pLF7Fs+VKCZWN
# GtLz7mG7SJrsqznLUQkj3gOlpPE5bT97J96nNiFaFFXH4gNOJd/7sRS6PcSbEWFx
# zU+fTzN96/nBMI+sSxGcBHA/u1XLbUnRMYIByTCCAcUCAQEwKDAUMRIwEAYDVQQD
# DAlsb2NhbGhvc3QCEB1vQ/tuaoaoTw/vFaf49fcwCQYFKw4DAhoFAKB4MBgGCisG
# AQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFLVH
# USd6JCfwA2rpxavPZJKXnTYqMA0GCSqGSIb3DQEBAQUABIIBABmc0DJ3IKpy60cg
# cqS5xU4fWtHk8QccewMX/tm8TPDvr8fWxHcfF4TWzSunE1Yzf6aZMt25eBrmZM1J
# HBYQTLHXgWQ3O7BuL+MuITIJWinyeAIxmGZs0AFtcddulnRfJwf+EkrPzq4tHLHZ
# uODwDgY68JxYl4GB+92ikbpamr9DTRAvFz467GfcE9akdFDL4BJQ5yS9ZneNr0id
# wV40+KrcLajU6AtLmUzpGz/WqrYM61G8T3JbkB+8Ibv78l8HoPwNXiZHsKSfRKvx
# KALEo7zqYKs/5IBBJc/cThzwlhg/+lHQmgJsOQIndexyOmvfSGNmBzyHqm3cbCFF
# sIFjNKo=
# SIG # End signature block
