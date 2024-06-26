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
# kkagggMSMIIDDjCCAfagAwIBAgIQeCYQxOzCh6hIVhxoajBlXjANBgkqhkiG9w0B
# AQsFADAUMRIwEAYDVQQDDAlsb2NhbGhvc3QwHhcNMjQwNjI2MDYxNzI5WhcNMjUw
# NjI2MDYzNzI5WjAUMRIwEAYDVQQDDAlsb2NhbGhvc3QwggEiMA0GCSqGSIb3DQEB
# AQUAA4IBDwAwggEKAoIBAQC6MANuT5ntjfzzrvTkb+eQSywqL896LbUyBk9KZdpg
# l/q/Hk+Kl35+vr5A4c8cywdyBB6pDiGLxY4nFjEfSK2cXT8tuq4fugodZ1wZ2QW2
# ZlxE74KMpX50KqbKhRL7XeOZJC422qnaywy6ezz2u4ujnYK9Frqn1Srfa1t9o5z9
# KFJ8/WhOhiF5ew0he8fAniI1VysvTS4SbIvbXLA4/5yQrv6xhhGCwuYKTYycV69T
# HMdehSaI1LYRDbttI5boATYFi0yh/CfksQvCqO86jrtm6JlUUXPRxzlGkAh9W2MO
# e28UEPucLN8q45y66XTg3x2YXoEQRnX+t+D4J9bpYJf1AgMBAAGjXDBaMA4GA1Ud
# DwEB/wQEAwIHgDAUBgNVHREEDTALgglsb2NhbGhvc3QwEwYDVR0lBAwwCgYIKwYB
# BQUHAwMwHQYDVR0OBBYEFHaflhRQRHOpq9oh+nyYqInlLPnfMA0GCSqGSIb3DQEB
# CwUAA4IBAQCr620eMWYQ1WK0dlMNXwowsiPNNj/cPhlRR2C9EKCyxhJJlMVb2yit
# z0v0StA6/QXyYDW1VVnHdHie7Wx82qnUAfhyMgycFt7f16PrKnDMU2t7fuztWX44
# lDu+1vgdq3ryylNjTyEHyx12chTgMuglb1JQ/5OmR5cWJaPFl7Sy7nLHZqa1ROcf
# 8pwjSuJcTnkCYaSqhow56Bn1uKd53DtrFE/TE6QtpkaVXkOjeopVLLJ4mZx1VJKh
# yCrZaUvUNjF40ZYxRbA6TmFK+yt4CbLwuGMTlW18fJUGwgtcXBHuZRaWpm86Ltyo
# rcuw1oFwx12+PWzhLiAzpN+AzjsXAfKqMYIByTCCAcUCAQEwKDAUMRIwEAYDVQQD
# DAlsb2NhbGhvc3QCEHgmEMTswoeoSFYcaGowZV4wCQYFKw4DAhoFAKB4MBgGCisG
# AQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFLVH
# USd6JCfwA2rpxavPZJKXnTYqMA0GCSqGSIb3DQEBAQUABIIBAHU0rbJJ+XstpDjM
# 06tJqlzyk4UGe19uupufDRe89eK5HWRSRzd64BTapaoLVNrcG3hN7KTi5ybEnyaK
# BM++HFIUXKQNp9ou34lAJ0bKLqyiJetzXDnDVMeYaTkLVwzhOeAilSaoDpwZWCyV
# DOugq5oTyhU4v6PDJIG1ufbVLpS9N0adlzcigolzzdL8wjKy0AcsB+X2CvMqkA1p
# I8MvTYwMOjXulwAKgU1fQ/7BXKpC0Agxmdxfq+dOXkGYWaXYwiXZTjQukD3Zmd/Q
# KPANgKIDTgwifA7HXRn5aRR5UWB4jLlVUqfpzav2X+XeBUk4rz/JjgIwUvT/QkBC
# ryMSul0=
# SIG # End signature block
