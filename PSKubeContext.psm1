
Function Select-KubeNamespace {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $False, Position = 0, ValueFromRemainingArguments = $True)]
        [Object[]] $Arguments
    )
    begin {
        if ($Arguments.Length -ge 1) {
            $ns = & kubectl get namespace -o=name $Arguments[0] 2>&1
            $ns = $ns -replace '^namespace/'
            if ($ns -ne $Arguments[0]) {
                $allNamespaces = kubectl get namespace -o=name;
                $allNamespaces = $allNamespaces | ForEach-Object {$_ -replace '^namespace/'};
                $filteredNamespaces = $allNamespaces | Where-Object {$_.StartsWith($Arguments[0])}
                if($null -eq $filteredNamespaces){
                    $filteredNamespaces = $allNamespaces;
                }
                $ns = Select-MenuOption -MenuOptions $filteredNamespaces;
            }
        }
        else {
            $allNamespaces = kubectl get namespace -o=name;
            $allNamespaces = $allNamespaces | ForEach-Object {$_ -replace '^namespace/'};
            $ns = Select-MenuOption -MenuOptions $allNamespaces;
        }
    }
    process {
        if ($ns -ne '') {
            $ns = $ns -replace '^namespace/'
            Write-Host "Set namespace to $ns";
            & kubectl config set-context --current --namespace=$ns
        }
    }
}

#kubectx
Function Select-KubeContext {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $False, Position = 0, ValueFromRemainingArguments = $True)]
        [Object[]] $Arguments
    )
    
    begin {
        if ($Arguments.Length -ge 1) {
            $ctx = & kubectl config get-contexts -o=name $Arguments[0] 2>&1
            if ($ctx -ne $Arguments[0]) {
                $allCtx = & kubectl config get-contexts -o=name
                $filteredCtx = $allCtx | Where-Object {$_.StartsWith($Arguments[0])}
                if($null -eq $filteredCtx){
                    $filteredCtx = $allCtx;
                }
                $ctx = Select-MenuOption -MenuOptions $filteredCtx;
            }
        }
        else {
            $allCtx = & kubectl config get-contexts -o=name
            $ctx = Select-MenuOption -MenuOptions $allCtx;
        }
    }
    process {
        if ($ctx -ne '') {
            & kubectl config use-context $ctx
        }
    }
}

Function Register-PSKubeAutoComplete {
    param (
        [parameter(Mandatory = $False, Position = 0)]
        [switch] $DisableForKubeNS,
        [parameter(Mandatory = $False, Position = 1)]
        [switch] $DisableForKubeCtx
    )

    if (!$DisableForKubeCtx) {
        $rootCommands = @('Select-KubeContext');
        $aliases = (get-alias).Where( { $_.Definition -in $rootCommands }).Name;
        if ($aliases) {
            $rootCommands += $aliases
        }
        Register-ArgumentCompleter -Native -CommandName $rootCommands -ScriptBlock {
            param($wordToComplete, $fullCommand, $cursorPosition)
            kubectl config get-contexts -o=name | ForEach-Object {
                $ctx = $_;
                if ($ctx.StartsWith($wordToComplete)) {
                    [System.Management.Automation.CompletionResult]::new($ctx, $ctx, 'ParameterValue', $ctx)
                }
                else {
                    # Write-Host "$ns doesnt startswith $wordToComplete"
                }
            }
        }
    } else {
        Write-Host "Autocomplete for Select-KubeContext (kubectx) will be disabled"
    }

    if  (!$DisableForKubeNS) {
        $rootCommands = @('Select-KubeNamespace');
        $aliases = (get-alias).Where( { $_.Definition -in $rootCommands }).Name;
        if ($aliases) {
            $rootCommands += $aliases
        }
        Register-ArgumentCompleter -Native -CommandName $rootCommands -ScriptBlock {
            param($wordToComplete, $fullCommand, $cursorPosition)
            kubectl get namespace -o=name | ForEach-Object {
                $ns = $_ -replace '^namespace/'
                if ($ns.StartsWith($wordToComplete)) {
                    [System.Management.Automation.CompletionResult]::new($ns, $ns, 'ParameterValue', $ns)
                }
                else {
                    # Write-Host "$ns doesnt startswith $wordToComplete"
                }
            }
        }
    } else {
        Write-Host "Autocomplete for Select-KubeContext (kubectx) will be disabled"
    }
}

# menu helper
Function Select-MenuOption (){
    Param(
        [Parameter(Mandatory=$True)]
        [string[]]$MenuOptions
    )
    
    $Count = $MenuOptions.count;
    $Selection = 0
    $EnterPressed = $False
    
    Clear-Host

    While($EnterPressed -eq $False){
        
        For ($i=0; $i -lt $Count; $i++){
            $back = $Host.UI.RawUI.BackgroundColor;
            $front = $Host.UI.RawUI.ForegroundColor;
            If ($i -eq $Selection){
                Write-Host -BackgroundColor $front -ForegroundColor $back "[ $($MenuOptions[$i]) ]"
            } Else {
                Write-Host "  $($MenuOptions[$i])  "
            }

        }

        $KeyInput = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown").virtualkeycode;
        Switch($KeyInput){
            13{
                $EnterPressed = $True
                Return $MenuOptions[$Selection]
                Clear-Host
                break
            }
            9{
                $Selection = ($Selection + 1) % $Count
                Clear-Host
                break
            }
            
            38{
                $Selection = ($Selection - 1 +$Count) % $Count
                Clear-Host
                break
            }

            40{
                $Selection = ($Selection + 1) % $Count
                Clear-Host
                break
            }
            Default{
                Clear-Host
            }
        }
    }
}