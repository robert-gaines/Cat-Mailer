
$plaintext = Read-Host "[+] Enter the plaintext string-> " 

try
{
    $convert_string = $plaintext | ConvertTo-SecureString -AsPlainText -Force

    $cipher_text = $convert_string | ConvertFrom-SecureString 

    $cipher_text | Out-File 'ciphertext.txt' -Encoding UTF8

    Write-Host -ForegroundColor Green "[*] Cipher text written to: ciphertext.txt "
}
catch
{
   Write-Host -ForegroundColor Red "[!] Failed to encipher the string" 
}

