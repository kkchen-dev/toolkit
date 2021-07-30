param(
    [String]
    $SourceFolder='D:\VisualStudio2019\Workspace\'
)

$ProjectFiles = Get-ChildItem "${SourceFolder}\*.csproj" -Recurse -Force
$Packages = [System.Collections.ArrayList]@()
foreach ($ProjectFile in $ProjectFiles) {
    $Xml = [xml](Get-Content $ProjectFile.PSPath)
    $Node = $(Select-Xml -Xml $Xml -XPath '//PackageReference').Node
    if ($Node) {
        if ($Node.GetType().Name -eq 'XmlElement') {
            $Node.SetAttribute("Directory", $ProjectFile.PSChildName)
            $null = $Packages.Add($Node)
        }
        else {
            foreach($N in $Node) {
                $Node.SetAttribute("Directory", $ProjectFile.PSChildName)
                $null = $Packages.Add($N)
            }
        }
    }
}
$Packages | Sort-Object "Include" | Out-File '.\Temp.txt'