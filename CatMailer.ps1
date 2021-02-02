<#A Script which sends random photos of cats via SMS or e-mail #>

function RetrieveImage()
{
    <# Call the REST API #>

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Content-Type", "application/json")

    <# 
    
        Please note: you'll need to add your own API key for this to work

    #>

    $headers.Add("x-api-key", "<API KEY GOES HERE>")

    $response = Invoke-RestMethod 'https://api.thecatapi.com/v1/images/search?format=json' -Method 'GET' -Headers $headers -Body $body

    $response_json = $response | ConvertTo-Json

    $data = $response_json | ConvertFrom-Json

    $url = $data[0].url

    <# Download the Cat Image #>

    Invoke-WebRequest -Uri $url -OutFile "RandomCat.jpg"
}

function DecryptString()
{
    #$currentDirectory = (Get-Location).Path

    #$subjectPath = $currentDirectory+'\ciphertext.txt'

    $subjectPath = "ciphertext.txt"

    $ciphertext_test = Test-Path -Path $subjectPath

    if($ciphertext_test)
    {
        try
        {
            $secure_string = Get-Content -Path $subjectPath | ConvertTo-SecureString

            $temp = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure_string)

            $password = [Runtime.InteropServices.Marshal]::PtrToStringAuto($temp) 
        
            return $password
        }
        catch
        {
            Write-Host -ForegroundColor Red "[!] Decryption sequence failed "
        }
    }
    else
    {
        Write-Host -ForegroundColor Red "[!] Failed to locate the file: ciphertext.txt"
    }
}

function main()
{
        <# Call embeds an image in the working directory #>

        RetrieveImage

        $computerName = $env:COMPUTERNAME

        $dateTime     = Get-Date

        $username     = "cat.transmitter@gmail.com"

        <# Call to read and decrypt the string stored in the adjacent text file #>

        $password     = DecryptString

        $password     = $password | ConvertTo-SecureString -AsPlainText -Force

        [pscredential]$credentials = New-Object System.Management.Automation.PSCredential ($username, $password)

        $body = "A random cat image for you" 

        Send-MailMessage -To "<Recipient goes here>" -From "cat.transmitter@gmail.com"  -Subject " A Random Cat Image " -Body $body -UseSsl:$true -SmtpServer "smtp.gmail.com" -Port 587 -Attachments 'RandomCat.jpg' -Credential $credentials  
       
}


<# Call the main function and transmit n cat photos to the recipient #>

for($i = 0; $i -lt 10; $i++)
{
    main

    Write-Host -ForegroundColor Green "[*] Message Sent "

    $delay = 15

    Write-Host -ForegroundColor Green "[*] Waiting: $delay seconds"

    Start-Sleep -Seconds $delay
}