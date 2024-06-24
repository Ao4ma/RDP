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
# kkagggMSMIIDDjCCAfagAwIBAgIQZf7IvaKJ5YFOrvx0+epQ7zANBgkqhkiG9w0B
# AQsFADAUMRIwEAYDVQQDDAlsb2NhbGhvc3QwHhcNMjQwNjI0MDA0NTU4WhcNMjUw
# NjI0MDEwNTU4WjAUMRIwEAYDVQQDDAlsb2NhbGhvc3QwggEiMA0GCSqGSIb3DQEB
# AQUAA4IBDwAwggEKAoIBAQD0+xnBMOaMI6lN6jPpT7GK5MM3LCAW/7NeywHMU50W
# rojrnam8Y5eDjamPSlFiSyB+EUgY2S9CWPA/2u9e3hoqdsGMht730OAhr4hyKHXT
# L4wbyp7lQ1+YaQpSgbCUD4afSHcoZFzqJWHe9tPZcFzwgAwt1rzMGRAyBD3zOU10
# ZqMaK9dJU/Zm5tf/Ucs5bD9hRiTCmiJL47keNLhpNl3T+TU6z4t9S46jOAyvxjzI
# NOUt7zTDOWjwD9UcYskj9bqMwM+tqPTt5wU7eXqDhTJiHHHjloxLP1VYpdimFcd2
# l2VXXXRGQPC9eQcja+/syW5uCkb4afBdrLlbvB8kgQblAgMBAAGjXDBaMA4GA1Ud
# DwEB/wQEAwIHgDAUBgNVHREEDTALgglsb2NhbGhvc3QwEwYDVR0lBAwwCgYIKwYB
# BQUHAwMwHQYDVR0OBBYEFAcysN2d7jV98TC6YfO7Xm/GsFMOMA0GCSqGSIb3DQEB
# CwUAA4IBAQBrTodmmq29+uWN2NMbwPV76dJtLjbv3bCZMkNIeMtI6y2q3JZ+JIrK
# uauBgxPZ9P+ksVfSSkGrssPZRcTcYCB42Xn8UYoQ1fQ0gkrlwc4LqsfeT+LmkacB
# qAB/aXKIQNGH030jcRAiL+dgsoO9r1/pYtZqklt9JMlmMwMSRJ07+4Fk1DxaLpQk
# Q5BKeT/VQLkVRCs1ZyukkTrZMfQoG8AsLr/PwFxb+fMPRqrKktBfNkSBHPqkDm9h
# wx0lZIcJaJ48DuTC+6L0Lo+PBuuA3b148Nq4KFNpQzWG368Pze22gKo1ZZH6xD0F
# EaJTdbEoVGqS7JUVP0VeDa5ijo7R3Lg0MYIByTCCAcUCAQEwKDAUMRIwEAYDVQQD
# DAlsb2NhbGhvc3QCEGX+yL2iieWBTq78dPnqUO8wCQYFKw4DAhoFAKB4MBgGCisG
# AQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFLVH
# USd6JCfwA2rpxavPZJKXnTYqMA0GCSqGSIb3DQEBAQUABIIBAIJIE80jQD4pGtli
# BDpxrYoAo/FzV9TiWSEX62MPRTzqcU/Nc/rLuyfYMaqv1/25aqrji0kKC9RKjxvq
# JVl0JOLC6mYZFE8NvC6C2F5WhZffSgKaDDOBvUw2joftcFwjVuqcE7MjYK10YFDl
# NvJv09GS5RtQc+kiJ/iuTZfGUFqhEsrRCT0GbnaSRYRa3z76Hk3u+Msz0PTKUOBw
# 1/zPCWFtdNDaK1qhG8VQBMZDgULJC77AsHcQkqagpjD1xPCCXYyp73H8ZtoPOYWn
# JQUcZQBo7Cb/CTl5gD10FjcAerz+VBTWusrqAkwxRV55C8NoBvNpSZa+OggDj+/b
# YhghE00=
# SIG # End signature block
