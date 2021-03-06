$ModuleName = 'PSAksDeployment'
Import-Module "$PSScriptRoot\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'General Module behaviour' {

    $ModuleInfo = Get-Module -Name $ModuleName
    $ManifestPath = Join-Path -Path $ModuleInfo.ModuleBase -ChildPath "$ModuleName.psd1"

    It 'The expected required modules are declared by the module' {

        Foreach ( $RequiredModule in $ModuleInfo.RequiredModules.Name ) {
            $RequiredModule | Should -BeIn @('Az.Accounts', 'Az.Resources', 'Az.Aks')
        }
    }
    It 'Has a valid manifest' {
        { Test-ModuleManifest -Path $ManifestPath -ErrorAction Stop } |
            Should Not Throw
    }
    It 'Has a valid root module' {
        $ModuleInfo.RootModule -like '*{0}.psm1' -f $ModuleName |
            Should -Be $True
    }

    $PublicFolder = Join-Path -Path $ModuleInfo.ModuleBase -ChildPath 'Public'
    $ExportedFunctions = $ModuleInfo.ExportedFunctions.Values.Name
    Foreach ( $ExpectedFunction in ((Get-ChildItem $PublicFolder -File).BaseName) ) {
        It "Exports function [$ExpectedFunction]" {
            $ExpectedFunction | Should -BeIn $ExportedFunctions
        }
    }
}
