$group = read-host Enter GroupiD
$gpassword = read-host Enter group password -AsSecureString
$user = read-host Enter UseriD
$password = read-host Enter password -AsSecureString

# セキュア文字列を複合して平文にします
$gpass = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR(
           [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($gpassword))
$pass  = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR(
           [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
 
# ヒアドキュメント（変数を展開する）
$str_here_document = @"
var global = {
  "documentCompleted": true
};

(function() {
  var IE = WScript.CreateObject( "InternetExplorer.Application", "ie_" );

  IE.Visible = true;
  IE.Navigate("$env:FMWW_SIGN_IN_URL");
  global.documentCompleted = false;
  while(!global.documentCompleted)
  {
      WScript.Sleep(10);
  }

  (function() {
    var i, x;
    var xs = [{
        "user":   ["form1:username",    "form1:password"],
        "person": ["form1:person_code", "form1:person_password"]
      },
      {
        "user":   ["form1:client", "form1:clpass"],
        "person": ["form1:person", "form1:pspass"]
      }
    ];

    for(i = 0; i < xs.length; ++i) {
      x = xs[i];
      if(IE.Document.getElementById(x.user[0])) {
        IE.Document.getElementById(x.user[0]).value = "$group";
        IE.Document.getElementById(x.user[1]).value = "$gpass";

        IE.Document.getElementById(x.person[0]).value = "$user";
        IE.Document.getElementById(x.person[1]).value = "$pass";
        IE.Document.getElementById("form1:login").click();
        break;
      }
    }
  })();
  WScript.Quit();
})();

function ie_DocumentComplete()
{
    global.documentCompleted = true;
}
"@
 
$fullName = "jmode.js"
# 標準出力に表示
# Write-Host $str_here_document
$str_here_document > $fullName
Start-Process -FilePath 'C:\Program Files\Windows Script Encoder\screnc.exe' -ArgumentList $fullName,jmode.jse -Wait
Remove-Item $fullName
