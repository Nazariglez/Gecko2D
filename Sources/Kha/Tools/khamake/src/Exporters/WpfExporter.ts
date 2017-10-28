import * as fs from 'fs-extra';
import * as path from 'path';
import {CSharpExporter} from './CSharpExporter';
import {convert} from '../Converter';
import {executeHaxe} from '../Haxe';
import {Options} from '../Options';
import {exportImage} from '../ImageTool';
const uuid = require('uuid');

export class WpfExporter extends CSharpExporter {
	constructor(options: Options) {
		super(options);
	}

	backend() {
		return 'WPF';
	}

	exportResources() {
		fs.ensureDirSync(path.join(this.options.to, this.sysdir() + '-build', 'Properties'));
		this.writeFile(path.join(this.options.to, this.sysdir() + '-build', 'Properties', 'AssemblyInfo.cs'));
		this.p('using System.Reflection;');
		this.p('using System.Resources;');
		this.p('using System.Runtime.CompilerServices;');
		this.p('using System.Runtime.InteropServices;');
		this.p('using System.Windows;');
		this.p();
		this.p('[assembly: AssemblyTitle("HaxeProject")]');
		this.p('[assembly: AssemblyDescription("")]');
		this.p('[assembly: AssemblyConfiguration("")]');
		this.p('[assembly: AssemblyCompany("KTX Software Development")]');
		this.p('[assembly: AssemblyProduct("HaxeProject")]');
		this.p('[assembly: AssemblyCopyright("Copyright ? KTX Software Development 2013")]');
		this.p('[assembly: AssemblyTrademark("")]');
		this.p('[assembly: AssemblyCulture("")]');
		this.p();
		this.p('[assembly: ComVisible(false)]');
		this.p();
		this.p('//[assembly: NeutralResourcesLanguage("en-US", UltimateResourceFallbackLocation.Satellite)]');
		this.p();
		this.p('[assembly: ThemeInfo(ResourceDictionaryLocation.None, ResourceDictionaryLocation.SourceAssembly)]');
		this.p();
		this.p('// [assembly: AssemblyVersion("1.0.*")]');
		this.p('[assembly: AssemblyVersion("1.0.0.0")]');
		this.p('[assembly: AssemblyFileVersion("1.0.0.0")]');
		this.closeFile();

		this.writeFile(path.join(this.options.to, this.sysdir() + '-build', 'Properties', 'Resources.Designer.cs'));
		this.p('namespace WpfApplication1.Properties {');
		this.p('[global::System.CodeDom.Compiler.GeneratedCodeAttribute("System.Resources.Tools.StronglyTypedResourceBuilder", "4.0.0.0")]', 1);
		this.p('[global::System.Diagnostics.DebuggerNonUserCodeAttribute()]', 1);
		this.p('[global::System.Runtime.CompilerServices.CompilerGeneratedAttribute()]', 1);
		this.p('internal class Resources', 1);
		this.p('{', 1);
		this.p('private static global::System.Resources.ResourceManager resourceMan;', 2);
		this.p('private static global::System.Globalization.CultureInfo resourceCulture;', 2);
		this.p();
		this.p('[global::System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")]', 2);
		this.p('internal Resources() { }', 2);
		this.p();
		this.p('[global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]', 2);
		this.p('internal static global::System.Resources.ResourceManager ResourceManager', 2);
		this.p('{', 2);
		this.p('get', 3);
		this.p('{', 3);
		this.p('if ((resourceMan == null))', 4);
		this.p('{', 4);
		this.p('global::System.Resources.ResourceManager temp = new global::System.Resources.ResourceManager("WpfApplication1.Properties.Resources", typeof(Resources).Assembly);', 5);
		this.p('resourceMan = temp;', 5);
		this.p('}', 4);
		this.p('return resourceMan;', 4);
		this.p('}', 3);
		this.p('}', 2);
		this.p();
		this.p('[global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]', 2);
		this.p('internal static global::System.Globalization.CultureInfo Culture', 2);
		this.p('{', 2);
		this.p('get', 3);
		this.p('{', 3);
		this.p('return resourceCulture;', 4);
		this.p('}', 3);
		this.p('set', 3);
		this.p('{', 3);
		this.p('resourceCulture = value;', 4);
		this.p('}', 3);
		this.p('}', 2);
		this.p('}', 1);
		this.p('}');
		this.closeFile();

		this.writeFile(path.join(this.options.to, this.sysdir() + '-build', 'Properties', 'Resources.resx'));
		this.p('<?xml version="1.0" encoding="utf-8"?>');
		this.p('<root>');
		this.p('<xsd:schema id="root" xmlns="" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata">');
		this.p('<xsd:element name="root" msdata:IsDataSet="true">');
		this.p('<xsd:complexType>');
		this.p('<xsd:choice maxOccurs="unbounded">');
		this.p('<xsd:element name="metadata">');
		this.p('<xsd:complexType>');
		this.p('<xsd:sequence>');
		this.p('<xsd:element name="value" type="xsd:string" minOccurs="0" />');
		this.p('</xsd:sequence>');
		this.p('<xsd:attribute name="name" type="xsd:string" />');
		this.p('<xsd:attribute name="type" type="xsd:string" />');
		this.p('<xsd:attribute name="mimetype" type="xsd:string" />');
		this.p('</xsd:complexType>');
		this.p('</xsd:element>');
		this.p('<xsd:element name="assembly">');
		this.p('<xsd:complexType>');
		this.p('<xsd:attribute name="alias" type="xsd:string" />');
		this.p('<xsd:attribute name="name" type="xsd:string" />');
		this.p('</xsd:complexType>');
		this.p('</xsd:element>');
		this.p('<xsd:element name="data">');
		this.p('<xsd:complexType>');
		this.p('<xsd:sequence>');
		this.p('<xsd:element name="value" type="xsd:string" minOccurs="0" msdata:Ordinal="1" />');
		this.p('<xsd:element name="comment" type="xsd:string" minOccurs="0" msdata:Ordinal="2" />');
		this.p('</xsd:sequence>');
		this.p('<xsd:attribute name="name" type="xsd:string" msdata:Ordinal="1" />');
		this.p('<xsd:attribute name="type" type="xsd:string" msdata:Ordinal="3" />');
		this.p('<xsd:attribute name="mimetype" type="xsd:string" msdata:Ordinal="4" />');
		this.p('</xsd:complexType>');
		this.p('</xsd:element>');
		this.p('<xsd:element name="resheader">');
		this.p('<xsd:complexType>');
		this.p('<xsd:sequence>');
		this.p('<xsd:element name="value" type="xsd:string" minOccurs="0" msdata:Ordinal="1" />');
		this.p('</xsd:sequence>');
		this.p('<xsd:attribute name="name" type="xsd:string" use="required" />');
		this.p('</xsd:complexType>');
		this.p('</xsd:element>');
		this.p('</xsd:choice>');
		this.p('</xsd:complexType>');
		this.p('</xsd:element>');
		this.p('</xsd:schema>');
		this.p('<resheader name="resmimetype">');
		this.p('<value>text/microsoft-resx</value>');
		this.p('</resheader>');
		this.p('<resheader name="version">');
		this.p('<value>2.0</value>');
		this.p('</resheader>');
		this.p('<resheader name="reader">');
		this.p('<value>System.Resources.ResXResourceReader, System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089</value>');
		this.p('</resheader>');
		this.p('<resheader name="writer">');
		this.p('<value>System.Resources.ResXResourceWriter, System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089</value>');
		this.p('</resheader>');
		this.p('</root>');
		this.closeFile();

		this.writeFile(path.join(this.options.to, this.sysdir() + '-build', 'Properties', 'Settings.Designer.cs'));
		this.p('namespace WpfApplication1.Properties');
		this.p('{');
		this.p('[global::System.Runtime.CompilerServices.CompilerGeneratedAttribute()]', 1);
		this.p('[global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.VisualStudio.Editors.SettingsDesigner.SettingsSingleFileGenerator", "10.0.0.0")]', 1);
		this.p('internal sealed partial class Settings : global::System.Configuration.ApplicationSettingsBase', 1);
		this.p('{', 1);
		this.p('private static Settings defaultInstance = ((Settings)(global::System.Configuration.ApplicationSettingsBase.Synchronized(new Settings())));', 2);
		this.p();
		this.p('public static Settings Default', 2);
		this.p('{', 2);
		this.p('get', 3);
		this.p('{', 3);
		this.p('return defaultInstance;', 4);
		this.p('}', 3);
		this.p('}', 2);
		this.p('}', 1);
		this.p('}');
		this.closeFile();

		this.writeFile(path.join(this.options.to, this.sysdir() + '-build', 'Properties', 'Settings.settings'));
		this.p('<?xml version="1.0" encoding="utf-8"?>');
		this.p('<SettingsFile xmlns="uri:settings" CurrentProfile="(Default)">');
		this.p('<Profiles>');
		this.p('<Profile Name="(Default)" />');
		this.p('</Profiles>');
		this.p('<Settings />');
		this.p('</SettingsFile>');

		this.closeFile();
	}

	exportCsProj(projectUuid: string) {
		this.writeFile(path.join(this.options.to, this.sysdir() + '-build', 'Project.csproj'));
		this.p('<?xml version="1.0" encoding="utf-8"?>');
		this.p('<Project ToolsVersion="4.0" DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">');
		this.p('<PropertyGroup>', 1);
		this.p('<Configuration Condition=" \'$(Configuration)\' == \'\' ">Debug</Configuration>', 2);
		this.p('<Platform Condition=" \'$(Platform)\' == \'\' ">x86</Platform>', 2);
		this.p('<ProductVersion>8.0.30703</ProductVersion>', 2);
		this.p('<SchemaVersion>2.0</SchemaVersion>', 2);
		this.p('<ProjectGuid>{' + projectUuid.toString().toUpperCase() + '}</ProjectGuid>', 2);
		this.p('<OutputType>Library</OutputType>', 2);
		this.p('<AppDesignerFolder>Properties</AppDesignerFolder>', 2);
		this.p('<RootNamespace>WpfApplication1</RootNamespace>', 2);
		this.p('<AssemblyName>WpfApplication1</AssemblyName>', 2);
		this.p('<TargetFrameworkVersion>v4.0</TargetFrameworkVersion>', 2);
		this.p('<TargetFrameworkProfile>Client</TargetFrameworkProfile>', 2);
		this.p('<FileAlignment>512</FileAlignment>', 2);
		this.p('<ProjectTypeGuids>{60dc8134-eba5-43b8-bcc9-bb4bc16c2548};{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}</ProjectTypeGuids>', 2);
		this.p('<WarningLevel>4</WarningLevel>', 2);
		this.p('</PropertyGroup>', 1);
		this.p('<PropertyGroup Condition=" \'$(Configuration)|$(Platform)\' == \'Debug|x86\' ">', 1);
		this.p('<PlatformTarget>x86</PlatformTarget>', 2);
		this.p('<DebugSymbols>true</DebugSymbols>', 2);
		this.p('<DebugType>full</DebugType>', 2);
		this.p('<Optimize>false</Optimize>', 2);
		this.p('<OutputPath>bin\\Debug\\</OutputPath>', 2);
		this.p('<DefineConstants>DEBUG;TRACE</DefineConstants>', 2);
		this.p('<ErrorReport>prompt</ErrorReport>', 2);
		this.p('<WarningLevel>4</WarningLevel>', 2);
		this.p('</PropertyGroup>', 1);
		this.p('<PropertyGroup Condition=" \'$(Configuration)|$(Platform)\' == \'Release|x86\' ">', 1);
		this.p('<PlatformTarget>x86</PlatformTarget>', 2);
		this.p('<DebugType>pdbonly</DebugType>', 2);
		this.p('<Optimize>true</Optimize>', 2);
		this.p('<OutputPath>bin\\Release\\</OutputPath>', 2);
		this.p('<DefineConstants>TRACE</DefineConstants>', 2);
		this.p('<ErrorReport>prompt</ErrorReport>', 2);
		this.p('<WarningLevel>4</WarningLevel>', 2);
		this.p('</PropertyGroup>', 1);
		this.p('<ItemGroup>', 1);
		this.p('<Reference Include="System" />', 2);
		this.p('<Reference Include="System.Data" />', 2);
		this.p('<Reference Include="System.Xml" />', 2);
		this.p('<Reference Include="Microsoft.CSharp" />', 2);
		this.p('<Reference Include="System.Core" />', 2);
		this.p('<Reference Include="System.Xml.Linq" />', 2);
		this.p('<Reference Include="System.Data.DataSetExtensions" />', 2);
		this.p('<Reference Include="System.Xaml">', 2);
		this.p('<RequiredTargetFramework>4.0</RequiredTargetFramework>', 3);
		this.p('</Reference>', 2);
		this.p('<Reference Include="WindowsBase" />', 2);
		this.p('<Reference Include="PresentationCore" />', 2);
		this.p('<Reference Include="PresentationFramework" />', 2);
		this.p('</ItemGroup>', 1);
		this.p('<ItemGroup>', 1);
		this.includeFiles(path.join(this.options.to, this.sysdir() + '-build', 'Sources', 'src'), path.join(this.options.to, this.sysdir() + '-build'));
		this.p('</ItemGroup>', 1);
		this.p('<ItemGroup>', 1);
		this.p('<Compile Include="Properties\\AssemblyInfo.cs">', 2);
		this.p('<SubType>Code</SubType>', 3);
		this.p('</Compile>', 2);
		this.p('<Compile Include="Properties\\Resources.Designer.cs">', 2);
		this.p('<AutoGen>True</AutoGen>', 3);
		this.p('<DesignTime>True</DesignTime>', 3);
		this.p('<DependentUpon>Resources.resx</DependentUpon>', 3);
		this.p('</Compile>', 2);
		this.p('<Compile Include="Properties\\Settings.Designer.cs">', 2);
		this.p('<AutoGen>True</AutoGen>', 3);
		this.p('<DependentUpon>Settings.settings</DependentUpon>', 3);
		this.p('<DesignTimeSharedInput>True</DesignTimeSharedInput>', 3);
		this.p('</Compile>', 2);
		this.p('<EmbeddedResource Include="Properties\\Resources.resx">', 2);
		this.p('<Generator>ResXFileCodeGenerator</Generator>', 3);
		this.p('<LastGenOutput>Resources.Designer.cs</LastGenOutput>', 3);
		this.p('</EmbeddedResource>', 2);
		this.p('<None Include="Properties\\Settings.settings">', 2);
		this.p('<Generator>SettingsSingleFileGenerator</Generator>', 3);
		this.p('<LastGenOutput>Settings.Designer.cs</LastGenOutput>', 3);
		this.p('</None>', 2);
		this.p('<AppDesigner Include="Properties\\" />', 2);
		this.p('</ItemGroup>', 1);
		this.p('<Import Project="$(MSBuildToolsPath)\\Microsoft.CSharp.targets" />', 1);
		this.p('</Project>');
		this.closeFile();
	}

	/*copyMusic(platform, from, to, encoders, callback) {
		Files.createDirectories(this.directory.resolve(this.sysdir()).resolve(to).parent());
		Converter.convert(from, this.directory.resolve(this.sysdir()).resolve(to + '.mp4'), encoders.aacEncoder, () => {
			callback([to + '.mp4']);
		});
	}*/

	async copySound(platform: string, from: string, to: string) {
		fs.copySync(from.toString(), path.join(this.options.to, this.sysdir(), to + '.wav'), { overwrite: true });
		return [to + '.wav'];
	}

	async copyVideo(platform: string, from: string, to: string) {
		fs.ensureDirSync(path.join(this.options.to, this.sysdir(), path.dirname(to)));
		await convert(from, path.join(this.options.to, this.sysdir(), to + '.wmv'), this.options.wmv);
		return [to + '.wmv'];
	}
}
