"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const fs = require("fs-extra");
const path = require("path");
const CSharpExporter_1 = require("./CSharpExporter");
const ImageTool_1 = require("../ImageTool");
const uuid = require('uuid');
function findIcon(from, options) {
    if (fs.existsSync(path.join(from, 'icon.png')))
        return path.join(from, 'icon.png');
    else
        return path.join(options.kha, 'Kore', 'Tools', 'kraffiti', 'ball.png');
}
class XnaExporter extends CSharpExporter_1.CSharpExporter {
    constructor(options) {
        super(options);
        this.images = [];
    }
    backend() {
        return 'XNA';
    }
    exportResources() {
        this.createDirectory(path.join(this.options.to, this.sysdir() + '-build', 'Properties'));
        this.writeFile(path.join(this.options.to, this.sysdir() + '-build', 'Properties', 'AssemblyInfo.cs'));
        this.p('using System.Reflection;');
        this.p('using System.Runtime.CompilerServices;');
        this.p('using System.Runtime.InteropServices;');
        this.p();
        this.p('[assembly: AssemblyTitle("WindowsGame1")]');
        this.p('[assembly: AssemblyProduct("WindowsGame1")]');
        this.p('[assembly: AssemblyDescription("")]');
        this.p('[assembly: AssemblyCompany("KTX Software Development")]');
        this.p('[assembly: AssemblyCopyright("Copyright ? KTX Software Development 2013")]');
        this.p('[assembly: AssemblyTrademark("")]');
        this.p('[assembly: AssemblyCulture("")]');
        this.p();
        this.p('[assembly: ComVisible(false)]');
        this.p();
        this.p('[assembly: Guid("9bc720e6-1f41-4daa-9629-0bc91d061f28")]');
        this.p();
        this.p('[assembly: AssemblyVersion("1.0.0.0")]');
        this.closeFile();
    }
    exportSLN(projectUuid) {
        fs.ensureDirSync(path.join(this.options.to, this.sysdir() + '-build'));
        this.writeFile(path.join(this.options.to, this.sysdir() + '-build', 'Project.sln'));
        let solutionUuid = uuid.v4();
        let contentUuid = uuid.v4();
        this.p('Microsoft Visual Studio Solution File, Format Version 11.00');
        this.p('# Visual Studio 2010');
        this.p('Project("{' + solutionUuid.toUpperCase() + '}") = "HaxeProject", "Project.csproj", "{' + projectUuid.toUpperCase() + '}"');
        this.p('EndProject');
        this.p('Project("{' + uuid.v4().toUpperCase() + '}") = "ProjectContent", "ProjectContent.contentproj", "{' + contentUuid.toUpperCase() + '}"');
        this.p('EndProject');
        this.p('Global');
        this.p('GlobalSection(SolutionConfigurationPlatforms) = preSolution', 1);
        this.p('Debug|x86 = Debug|x86', 2);
        this.p('Release|x86 = Release|x86', 2);
        this.p('EndGlobalSection', 1);
        this.p('GlobalSection(ProjectConfigurationPlatforms) = postSolution', 1);
        this.p('{" + projectUuid.toString().toUpperCase() + "}.Debug|x86.ActiveCfg = Debug|x86', 2);
        this.p('{" + projectUuid.toString().toUpperCase() + "}.Debug|x86.Build.0 = Debug|x86', 2);
        this.p('{" + projectUuid.toString().toUpperCase() + "}.Release|x86.ActiveCfg = Release|x86', 2);
        this.p('{" + projectUuid.toString().toUpperCase() + "}.Release|x86.Build.0 = Release|x86', 2);
        this.p('{" + contentUuid.toString().toUpperCase() + "}.Debug|x86.ActiveCfg = Debug|x86', 2);
        this.p('{" + contentUuid.toString().toUpperCase() + "}.Release|x86.ActiveCfg = Release|x86', 2);
        this.p('EndGlobalSection', 1);
        this.p('GlobalSection(SolutionProperties) = preSolution', 1);
        this.p('HideSolutionNode = FALSE', 2);
        this.p('EndGlobalSection', 1);
        this.p('EndGlobal');
        this.closeFile();
        this.writeFile(path.join(this.options.to, this.sysdir() + '-build', 'ProjectContent.contentproj'));
        this.p('<?xml version="1.0" encoding="utf-8"?>');
        this.p('<Project DefaultTargets="Build" ToolsVersion="4.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">');
        this.p('<PropertyGroup>', 1);
        this.p('<ProjectGuid>{4D596EAA-8942-4AAD-967E-4D2A08374564}</ProjectGuid>', 2);
        this.p('<ProjectTypeGuids>{96E2B04D-8817-42c6-938A-82C39BA4D311};{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}</ProjectTypeGuids>', 2);
        this.p('<Configuration Condition=" \'$(Configuration)\' == \'\' ">Debug</Configuration>', 2);
        this.p('<Platform Condition=" \'$(Platform)\' == \'\' ">x86</Platform>', 2);
        this.p('<OutputType>Library</OutputType>', 2);
        this.p('<AppDesignerFolder>Properties</AppDesignerFolder>', 2);
        this.p('<TargetFrameworkVersion>v4.0</TargetFrameworkVersion>', 2);
        this.p('<XnaFrameworkVersion>v4.0</XnaFrameworkVersion>', 2);
        this.p('<OutputPath>bin\\$(Platform)\\$(Configuration)</OutputPath>', 2);
        this.p('<ContentRootDirectory>Content</ContentRootDirectory>', 2);
        this.p('</PropertyGroup>', 1);
        this.p('<PropertyGroup Condition="\'$(Configuration)|$(Platform)\' == \'Debug|x86\'">', 1);
        this.p('<PlatformTarget>x86</PlatformTarget>', 2);
        this.p('</PropertyGroup>', 1);
        this.p('<PropertyGroup Condition="\'$(Configuration)|$(Platform)\' == \'Release|x86\'">', 1);
        this.p('<PlatformTarget>x86</PlatformTarget>', 2);
        this.p('</PropertyGroup>', 1);
        this.p('<PropertyGroup>', 1);
        this.p('<RootNamespace>KhaContent</RootNamespace>', 2);
        this.p('</PropertyGroup>', 1);
        this.p('<ItemGroup>', 1);
        this.p('<Reference Include=Microsoft.Xna.Framework.Content.Pipeline.EffectImporter, Version=4.0.0.0, Culture=neutral, PublicKeyToken=842cf8be1de50553, processorArchitecture=MSIL" />', 2);
        this.p('<Reference Include="Microsoft.Xna.Framework.Content.Pipeline.FBXImporter, Version=4.0.0.0, Culture=neutral, PublicKeyToken=842cf8be1de50553, processorArchitecture=MSIL" />', 2);
        this.p('<Reference Include="Microsoft.Xna.Framework.Content.Pipeline.TextureImporter, Version=4.0.0.0, Culture=neutral, PublicKeyToken=842cf8be1de50553, processorArchitecture=MSIL" />', 2);
        this.p('<Reference Include="Microsoft.Xna.Framework.Content.Pipeline.XImporter, Version=4.0.0.0, Culture=neutral, PublicKeyToken=842cf8be1de50553, processorArchitecture=MSIL" />', 2);
        this.p('<Reference Include="Microsoft.Xna.Framework.Content.Pipeline.AudioImporters, Version=4.0.0.0, Culture=neutral, PublicKeyToken=842cf8be1de50553, processorArchitecture=MSIL" />', 2);
        this.p('<Reference Include="Microsoft.Xna.Framework.Content.Pipeline.VideoImporters, Version=4.0.0.0, Culture=neutral, PublicKeyToken=842cf8be1de50553, processorArchitecture=MSIL" />', 2);
        this.p('</ItemGroup>', 1);
        for (let image of this.images) {
            this.p('<ItemGroup>', 1);
            this.p('<Compile Include="bin\\' + image + '">', 2);
            this.p('<Name>' + image.substr(0, image.length - 4) + '</Name>', 3);
            this.p('<Importer>TextureImporter</Importer>', 3);
            this.p('<Processor>TextureProcessor</Processor>', 3);
            this.p('</Compile>', 2);
            this.p('</ItemGroup>', 1);
        }
        this.p('<Import Project="$(MSBuildExtensionsPath)\\Microsoft\\XNA Game Studio\\$(XnaFrameworkVersion)\\Microsoft.Xna.GameStudio.ContentPipeline.targets" />', 1);
        this.p('</Project>');
        this.closeFile();
    }
    exportCsProj(projectUuid) {
        ImageTool_1.exportImage(this.options.kha, findIcon(this.options.to, this.options), path.join(this.options.to, this.sysdir() + '-build', 'GameThumbnail.png'), { width: 64, height: 64 }, 'png', false, false, {});
        ImageTool_1.exportImage(this.options.kha, findIcon(this.options.to, this.options), path.join(this.options.to, this.sysdir() + '-build', 'Game.ico'), null, 'ico', false, false, {});
        this.writeFile(path.join(this.options.to, this.sysdir() + '-build', 'Project.csproj'));
        this.p('<?xml version="1.0" encoding="utf-8"?>');
        this.p('<Project DefaultTargets="Build" ToolsVersion="4.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">');
        this.p('<PropertyGroup>', 1);
        this.p('<ProjectGuid>{' + projectUuid.toUpperCase() + '}</ProjectGuid>', 2);
        this.p('<ProjectTypeGuids>{6D335F3A-9D43-41b4-9D22-F6F17C4BE596};{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}</ProjectTypeGuids>', 2);
        this.p('<Configuration Condition=" \'$(Configuration)\' == \'\' ">Debug</Configuration>', 2);
        this.p('<Platform Condition=" \'$(Platform)\' == \'\' ">x86</Platform>', 2);
        this.p('<OutputType>WinExe</OutputType>', 2);
        this.p('<AppDesignerFolder>Properties</AppDesignerFolder>', 2);
        this.p('<RootNamespace>WindowsGame1</RootNamespace>', 2);
        this.p('<AssemblyName>KhaGame</AssemblyName>', 2);
        this.p('<TargetFrameworkVersion>v4.0</TargetFrameworkVersion>', 2);
        this.p('<TargetFrameworkProfile>Client</TargetFrameworkProfile>', 2);
        this.p('<XnaFrameworkVersion>v4.0</XnaFrameworkVersion>', 2);
        this.p('<XnaPlatform>Windows</XnaPlatform>', 2);
        this.p('<XnaProfile>Reach</XnaProfile>', 2);
        this.p('<XnaCrossPlatformGroupID>d431ff8d-bafa-420e-8740-c2c1114d7ac2</XnaCrossPlatformGroupID>', 2);
        this.p('<XnaOutputType>Game</XnaOutputType>', 2);
        this.p('<ApplicationIcon>Game.ico</ApplicationIcon>', 2);
        this.p('<Thumbnail>GameThumbnail.png</Thumbnail>', 2);
        this.p('<PublishUrl>publish\\</PublishUrl>', 2);
        this.p('<Install>true</Install>', 2);
        this.p('<InstallFrom>Disk</InstallFrom>', 2);
        this.p('<UpdateEnabled>false</UpdateEnabled>', 2);
        this.p('<UpdateMode>Foreground</UpdateMode>', 2);
        this.p('<UpdateInterval>7</UpdateInterval>', 2);
        this.p('<UpdateIntervalUnits>Days</UpdateIntervalUnits>', 2);
        this.p('<UpdatePeriodically>false</UpdatePeriodically>', 2);
        this.p('<UpdateRequired>false</UpdateRequired>', 2);
        this.p('<MapFileExtensions>true</MapFileExtensions>', 2);
        this.p('<ApplicationRevision>0</ApplicationRevision>', 2);
        this.p('<ApplicationVersion>1.0.0.%2a</ApplicationVersion>', 2);
        this.p('<IsWebBootstrapper>false</IsWebBootstrapper>', 2);
        this.p('<UseApplicationTrust>false</UseApplicationTrust>', 2);
        this.p('<BootstrapperEnabled>true</BootstrapperEnabled>', 2);
        this.p('</PropertyGroup>', 1);
        this.p('<PropertyGroup Condition=" \'$(Configuration)|$(Platform)\' == \'Debug|x86\' ">', 1);
        this.p('<DebugSymbols>true</DebugSymbols>', 2);
        this.p('<DebugType>full</DebugType>', 2);
        this.p('<Optimize>false</Optimize>', 2);
        this.p('<OutputPath>bin\\x86\\Debug</OutputPath>', 2);
        this.p('<DefineConstants>DEBUG;TRACE;WINDOWS</DefineConstants>', 2);
        this.p('<ErrorReport>prompt</ErrorReport>', 2);
        this.p('<WarningLevel>4</WarningLevel>', 2);
        this.p('<NoStdLib>true</NoStdLib>', 2);
        this.p('<UseVSHostingProcess>false</UseVSHostingProcess>', 2);
        this.p('<PlatformTarget>x86</PlatformTarget>', 2);
        this.p('<XnaCompressContent>false</XnaCompressContent>', 2);
        this.p('</PropertyGroup>', 1);
        this.p('<PropertyGroup Condition=" \'$(Configuration)|$(Platform)\' == \'Release|x86\' ">', 1);
        this.p('<DebugType>pdbonly</DebugType>', 2);
        this.p('<Optimize>true</Optimize>', 2);
        this.p('<OutputPath>bin\\x86\\Release</OutputPath>', 2);
        this.p('<DefineConstants>TRACE;WINDOWS</DefineConstants>', 2);
        this.p('<ErrorReport>prompt</ErrorReport>', 2);
        this.p('<WarningLevel>4</WarningLevel>', 2);
        this.p('<NoStdLib>true</NoStdLib>', 2);
        this.p('<UseVSHostingProcess>false</UseVSHostingProcess>', 2);
        this.p('<PlatformTarget>x86</PlatformTarget>', 2);
        this.p('<XnaCompressContent>true</XnaCompressContent>', 2);
        this.p('</PropertyGroup>', 1);
        this.p('<ItemGroup>', 1);
        this.p('<Reference Include="Microsoft.Xna.Framework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=842cf8be1de50553, processorArchitecture=x86" />', 2);
        this.p('<Reference Include="Microsoft.Xna.Framework.Game, Version=4.0.0.0, Culture=neutral, PublicKeyToken=842cf8be1de50553, processorArchitecture=x86" />', 2);
        this.p('<Reference Include="Microsoft.Xna.Framework.Graphics, Version=4.0.0.0, Culture=neutral, PublicKeyToken=842cf8be1de50553, processorArchitecture=x86" />', 2);
        this.p('<Reference Include="Microsoft.Xna.Framework.GamerServices, Version=4.0.0.0, Culture=neutral, PublicKeyToken=842cf8be1de50553, processorArchitecture=x86" />', 2);
        this.p('<Reference Include="mscorlib" />', 2);
        this.p('<Reference Include="System" />', 2);
        this.p('<Reference Include="System.Xml" />', 2);
        this.p('<Reference Include="System.Core" />', 2);
        this.p('<Reference Include="System.Xml.Linq" />', 2);
        this.p('<Reference Include="System.Net" />', 2);
        this.p('</ItemGroup>', 1);
        this.p('<ItemGroup>', 1);
        this.p('<Compile Include="Properties\\AssemblyInfo.cs" />', 2);
        this.includeFiles(path.join(this.options.to, this.sysdir() + '-build', 'Sources', 'src'), path.join(this.options.to, this.sysdir() + '-build'));
        this.p('</ItemGroup>', 1);
        this.p('<ItemGroup>', 1);
        this.p('<Content Include="Game.ico" />', 2);
        this.p('<Content Include="GameThumbnail.png">', 2);
        this.p('<XnaPlatformSpecific>true</XnaPlatformSpecific>', 3);
        this.p('</Content>', 2);
        this.p('</ItemGroup>', 1);
        this.p('<ItemGroup>', 1);
        this.p('<ProjectReference Include="ProjectContent.contentproj">', 2);
        this.p('<Name>ProjectContent</Name>', 3);
        this.p('<XnaReferenceType>Content</XnaReferenceType>', 3);
        this.p('</ProjectReference>', 2);
        this.p('</ItemGroup>', 1);
        this.p('<ItemGroup>', 1);
        this.p('<BootstrapperPackage Include=".NETFramework,Version=v4.0,Profile=Client">', 2);
        this.p('<Visible>False</Visible>', 3);
        this.p('<ProductName>Microsoft .NET Framework 4 Client Profile %28x86 und x64%29</ProductName>', 3);
        this.p('<Install>true</Install>', 3);
        this.p('</BootstrapperPackage>', 2);
        this.p('<BootstrapperPackage Include="Microsoft.Net.Client.3.5">', 2);
        this.p('<Visible>False</Visible>', 3);
        this.p('<ProductName>.NET Framework 3.5 SP1 Client Profile</ProductName>', 3);
        this.p('<Install>false</Install>', 3);
        this.p('</BootstrapperPackage>', 2);
        this.p('<BootstrapperPackage Include="Microsoft.Net.Framework.3.5.SP1">', 2);
        this.p('<Visible>False</Visible>', 3);
        this.p('<ProductName>.NET Framework 3.5 SP1</ProductName>', 3);
        this.p('<Install>false</Install>', 3);
        this.p('</BootstrapperPackage>', 2);
        this.p('<BootstrapperPackage Include="Microsoft.Windows.Installer.3.1">', 2);
        this.p('<Visible>False</Visible>', 3);
        this.p('<ProductName>Windows Installer 3.1</ProductName>', 3);
        this.p('<Install>true</Install>', 3);
        this.p('</BootstrapperPackage>', 2);
        this.p('<BootstrapperPackage Include="Microsoft.Xna.Framework.4.0">', 2);
        this.p('<Visible>False</Visible>', 3);
        this.p('<ProductName>Microsoft XNA Framework Redistributable 4.0</ProductName>', 3);
        this.p('<Install>true</Install>', 3);
        this.p('</BootstrapperPackage>', 2);
        this.p('</ItemGroup>', 1);
        this.p('<Import Project="$(MSBuildBinPath)\\Microsoft.CSharp.targets" />', 1);
        this.p('<Import Project="$(MSBuildExtensionsPath)\\Microsoft\\XNA Game Studio\\Microsoft.Xna.GameStudio.targets" />', 1);
        this.p('</Project>');
        this.closeFile();
    }
    copyImage(platform, from, to, asset, cache) {
        return __awaiter(this, void 0, void 0, function* () {
            this.images.push(asset['file']);
            let format = yield ImageTool_1.exportImage(this.options.kha, from, path.join(this.options.to, 'xna', to), asset, undefined, false, false, cache);
            return [to + '.' + format];
        });
    }
}
exports.XnaExporter = XnaExporter;
//# sourceMappingURL=XnaExporter.js.map