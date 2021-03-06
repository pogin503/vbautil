# Indicates that Windows PowerShell returns an exception if a variable is referenced before a value is assigned to the variable.
Set-PSDebug -strict

# enable debugger
# 0 - Turn script tracing off
# 1 - Trace script lines as they are executed
# 2 - Trace script lines, variable assignments, function calls, and scripts.
Set-PSDebug -trace 2

# step
Set-PSDebug -step

 # Establishes and enforces coding rules in expressions, scripts, and script blocks.
Set-StrictMode -Version 1.0
Set-StrictMode -Version 2.0
Set-StrictMode -Version 3.0
Set-StrictMode -Version Latest

# 規則の解除
Set-StrictMode -Off

# Restricted - 実行できるスクリプトはありません。Windows PowerShell は対話型モードでのみ使用できます。
# AllSigned - 信頼できる発行元が署名したスクリプトのみを実行できます。
# RemoteSigned - ダウンロードしたスクリプトは信頼できる発行元が署名した場合にのみ実行できます。
# Unrestricted - 制限なし。すべての Windows PowerShell スクリプトを実行できます。
Set-ExecutionPolicy RemoteSigned
Get-ExecutionPolicy

# コマンドレットでエラーがあった場合、処理を中断させる
$ErrorActionPreference = "Stop"

# print environment value
# env
dir env:*

# print PATH
# echo $PATH
$env:Path

# pretty printed path
dir $env:Path | % { $_.Value -split ";" }

# create current directory
# mkdir $(date +'%Y%m%d')
mkdir ("{0:yyyyMMdd}" -f (Get-Date))

# $(date +'%Y%m%d')
$now = Get-Date -Format "yyyyMMdd_HHmmss"
$now
#=> 20170702_190530

# @see http://powershell.web.fc2.com/Html/Index.html

Get-Process | Where-Object {$_.handles -gt 500} | Select-Object -first 5

Get-EventLog -logName Application -newest 15

@(3,5,10,1,2,1,1,1,2,6,4,4) | Sort-Object | Get-Unique
 
# ========================================================================
# data structure, library

# array
$arr1 = @()
$arr2 = 1,2,3

$arr_len = arr2.Length
$arr2 += 4
$arr3 = 5,6,7
$arr4 = $arr2 + $arr3
$arr2 -contains 2

# hash table
$hash = @{hoge="HOGE"; fuga="FUGA"; piyo="PIYO"}
echo $hash.GetType().Name #=> Hashtable
echo ("hoge = " + hoge["hoge"])
echo ("fuga = " + hoge.Item["fuga"])

# hash table
echo $hash.Keys
echo $hash.Values
foreach ($key in $hash.Keys) {
    $key + ":" + $hash.[$key]
}

# Set
# @see https://msdn.microsoft.com/en-us/library/bb359438.aspx
$set = New-Object System.Collections.Generic.HashSet[int]

# more
# @see https://www.simple-talk.com/sysadmin/powershell/powershell-one-liners-collections-hashtables-arrays-and-strings/

# regexp
$result = "abc" -replace "c","d"

# ========================================================================
# Syntax

# if
<#
if (...) {

} elseif (...) {

} else {

}
#>

# while
$x = 0
while ($x -lt 5) {
    $x += 1
    Write-Output $x
}

# foreach
$items = 1..10
foreach ($item in $items) {
    write-output $item
}

# switch
$i = 3
switch ($i) {
    1 {"1"; break}
    2 {"2"; break}
    {$_ -lt 5} {"5より小さい"; break}
    default {"default句"; break}
}

# operator
$num1 = 1
$num2 = 2
$num1 -eq $num2 # == $num1は$num2と等しい
$num1 -ne $num2 # != $num1は$num2は等しくない
$num1 -lt $num2 # <  $num1は$num2より小さい
$num1 -gt $num2 # >  $num1は$num2より大きい
$num1 -le $num2 # <= $num1は$num2以下
$num1 -ge $num2 # >= $num1は$num2以上

# logical operator
$ret = -not $true
$ret = !$true
$ret = $true -and $false
$ret = $true -or  $false
$ret = $true -xor $false

# scope
# どのスコープからも読み書き可能
$global:a = 1
# 現在のスコープからのみ読み書き可能
$private:a = 1
# 現在のスクリプトからのみ読み書き可能
$script:a = 1

# etc

# -ieq case insensitive
# -ceq case sensitive

# ========================================================================
# command

# ls -1
ls -Name

# grep
gc somefile.txt | where { $_ -match “expression”}

# head
gc log.txt | select -first 10
gc -TotalCount 10 log.txt

# tail
gc log.txt | select -last 10
gc -Tail 10 log.txt # tail (since PSv3), also much faster than above option

# sed
cat somefile.txt | % { $_ -replace "expression","replace" }

# find .
ls -r
ls -Recursive

# find . -type f
ls -r -File -Name

# find . -type d
ls -r -Directory -Name

# find . -type f -name "expression"
ls -r -File -i "expression"

# touch
New-Item -ItemType file newfile

# @see http://qiita.com/opengl-8080/items/bb0f5e4f1c7ce045cc57
# @see http://stackoverflow.com/questions/9682024/how-to-do-what-head-tail-more-less-sed-do-in-powershell

# basename "$0"
$myInvocation.myCommand.Path

# -z  test -z string	string の文字列長が 0 ならば真となる。
"".length -eq "".length

# -n	test -n string	string の文字列長が 0 より大ならば真となる。
"1".length -gt "".length

# -d	test -d file	file がディレクトリならば真となる。
Test-Path ~/ -PathType Container

# -f	test -f file	file が普通のファイルならば真となる。
Test-Path ~/.zshrc -PathType Leaf

# -s	test -s file	file が 0 より大きいサイズならば真となる。
# -e	test -e file	file が存在するならば真となる。
# -r	test -r file	file が読み取り可能ならば真となる。
# -w	test -w file	file が書き込み可能ならば真となる。
# -x	test -x file	file が実行可能ならば真となる。

# is null or empty
[string]::IsNullOrEmpty("")
[string]::IsNullOrEmpty($null)

# "${base%/}/${rel}"
Write-Output (Join-Path "~/" ".zshrc")

# dirname (readlink -f /Users/pogin/.bashrc)
Write-Output (Split-Path -Parent "/Users/pogin/.bashrc")

# basename /foo/bar/baz
Split-Path -Leaf .zshrc

# realpath ~/.zshrc
Resolve-Path ./.zshrc
Resolve-Path "C:¥path¥of¥relative¥..¥..¥"

$data = ls -r -i "*.ps1" | % { $_.Fullname } | % { notepad.exe $_ }

# ========================================================================
# JSON file path
$jsonFile = "C:¥Path¥to¥jsonfile.json"

# ライブラリの参照を追加
[System.Reflection.Assembly]::LoadWithPartialName ("System.Web.Extension")

# メソッド参照用のオブジェクトを定義
$ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer

# オブジェクトにデシリアライズする
$json = $ser.DeserializeObject((Get-Content $jsonFile -encoding utf8))

# JSONデータの参照
$json[‘Directory']
