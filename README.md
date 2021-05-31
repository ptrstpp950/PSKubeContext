# PSKubeContext
Powershell native implementation of kubectx and kubens with autocomplete

## How to use
Install it with
```
Install-Module PSKubeContext
```

To utilize it, simply add the following to your profile:
```
Import-Module PSKubeContext
Set-Alias kubens -Value Select-KubeNamespace
Set-Alias kubectx -Value Select-KubeContext
Register-PSKubeAutoComplete
```

## What's inside:

- `Select-KubeContext` or if you prefer alias `kubectx`
- `Select-KubeNamespace` or `kubens`
- 100% autocomplete using <TAB> 🙈🙉🙊
- A menu in command line to select the context/namespace if something goes wrong 😅


## Demo
Check this YouTube video: https://www.youtube.com/embed/_6XjdLD0TWo
