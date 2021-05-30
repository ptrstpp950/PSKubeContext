#
# Module manifest for module 'PSKubeContext'
#
# Generated by: Piotr Stapp
#
# Generated on: 28-May-2021
#
@{
    # Version number of this module.
    ModuleVersion     = '0.0.0.1'
    # Script module or binary module file associated with this manifest.
    RootModule        = 'PSKubeContext.psm1'
    # ID used to uniquely identify this module
    GUID              = 'e52b0a52-1f83-4036-8162-3868b374e201'
    # Company or vendor of this module
    CompanyName       = 'Unknown'
    # Author of this module
    Author            = 'Piotr Stapp'
    # Copyright statement for this module
    Copyright         = '(c) 2021 Piotr Stapp. All rights reserved.'
    # Description of the functionality provided by this module
    Description       = 'A native PowerShell version of kubectx and kubens'
    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.0'
    # List of all files packaged with this module
    FileList          = @()
    # Cmdlets to export from this module
    CmdletsToExport   = @()
    # Variables to export from this module
    VariablesToExport = @()
    # Aliases to export from this module
    AliasesToExport   = '*'
    # Functions to export from this module
    FunctionsToExport = @('Select-KubeContext', 'Select-KubeNamespace', 'Register-PSKubeAutoComplete')
    # Private data to pass to the module specified in RootModule. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{
        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags       = @('kubernetes', 'k8s', 'kubens', 'kubectx')
            # A URL to the license for this module.
            #LicenseUri = ''
            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/ptrstpp950/'
        } # End of PSData hashtable
    } # End of PrivateData hashtable
}