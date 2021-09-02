
一、Blog
https://www.jianshu.com/p/88c1b65e3ddb


3分钟实现iOS语言本地化/国际化（图文详解）

## 前言

语言本地化，又叫做语言国际化。是指根据用户操作系统的语言设置，自动将应用程序的语言设置为和用户操作系统语言一致的语言。往往一些应用程序需要提供给多个国家的人群使用，或者一个国家有多种语言，这就要求应用程序所展示的文字、图片等信息，能够让讲不同语言的用户读懂、看懂。进而提出为同一个应用程序适配多种语言，也即是国际化。语言国际化之所以又叫做语言本地化，这是站在每个用户的角度而言的，是指能够让用户本地、本土人群能够看懂的语言信息，顾名思义，语言本地化。其实语言本地化 == 语言国际化！
本文将分如下7个主要章节一步一步讲解如何完全本地化一个App。

配置需要国际化的语言（国际化的准备工作）
App名称本地化
代码中字符串本地化
多人开发情况下的字符串本地化
图片本地化（两种方式两种方式）
查看/切换本地语言
storyboard/xib本地化


## 配置需要国际化的语言

配置需要国际化的语言，这也是国际化之前的准备工作，无论我们是国际化App名称、代码中的字符串、图片、还是storyboard和xib，都需要进行这一步的准备工作（一个项目中需要且仅需要配置一次）。

选中project->Info->Localizations，然后点击"+"，添加需要国际化/本地化的语言，如下图（默认需要勾选Use Base Internationalization）：

备注： “zh-Hans”和“zh-Hant”是简体中文和繁体中文的缩写。这是标准的缩写。H可大写也可小写。"en"是英语的缩写。ko是韩语的缩写，fr是法语的缩写。其他语言请百度各国语言缩写即可查询。


# （一）应用名称本地化/国际化

应用名称本地化，是指同一个App的名称，在不同的语言环境下（也就是手机设备的语言设置）显示不同的名称。比如，微信在简体中文环境下App名称显示为“微信”，在英语环境下显示为“weChat”。下面就开始进行应用名称本地化。


1、选中Info.plist，按下键盘上的command + N，选择Strings File（iOS->Resource->Strings File）
2、文件名字命名为InfoPlist，且必须是这个名字（因每个人电脑设置差异，此处本人电脑没有显示strings后缀名）:
3、点击create后，Xcode左侧导航列表就会出现名为InfoPlist.strings的文件
4、选中InfoPlist.strings，在Xcode的File inspection（Xcode右侧文件检查器）中点击Localize，目的是选择我们需要本地化的语言

    注意：在点击Localize之前，一定要保证我们已经添加了需要本地化的语言，也就是上面配置需要国际化的语言那一步（步骤：project->Info->Localizations，然后点击"+"，添加需要国际化/本地化的语言）。
5、点击Localize后，会弹出一个对话框，展开对话框列表，发现下拉列表所展示的语言正是我们在上面配置的需要国际化的语言，选择我们需要本地化的语言，然后点击对话框的Localize按钮

    注意：如果我们没有在 PROJECT 中配置需要国际化的语言（project->Info->Localizations，然后点击"+"），上图下拉列表中将只会出现"Base"和"English"选项，English语言是系统默认的语言，其他需要国际化的语言（例如中文简体、法语）必须通过上面的配置本地化语言那一步手动添加。

6、然后我们发现Xcode右侧的File inspection的样式改变：
7、接下来，勾选French、Chinese（zh-Hans）、Chinese（zh-Hant）、Korean，如下图：
8、此时，Xcode左侧的InfoPlist.stirings左侧多了一个箭头，点击箭头可以展开
    从上图可以看出，InfoPlist.strings文件下包含了English、French、Chinese（Simplified）、Chinese（Traditional）、Korean这五种语言的文件。


    原理：程序启动时，会根据操作系统设置的语言，自动加载InfoPlist.strings文件下对应的语言文件，然后显示应用程序的名字。

9、接下来，我们分别用不同的语言给InfoPlist.strings下的文件设置对应的名字。
    （1）在InfoPlist.strings(english)中加入如下代码：
            // Localizable App Name是App在英语环境环境下显示的名称
            CFBundleDisplayName = "Localizable App Name";

            备注：CFBundleDisplayName可以使用双引号，也可以不使用双引号！
    （2）在InfoPlist.strings(French)中加入如下代码：
            CFBundleDisplayName = "Le nom de la localisation de l'App";


    备注：过去本地化App名称，需要在Info.plist文件中增加一个名为“Application has localized display name”的BOOL类型的Key，并且需要将其值设置为YES（如下图）。目的是让App支持本地化App名称。但现在可以忽略这一步。

    在Project的设置中通过点击"+"添加需要本地化的语言。
    然后在Xcode右侧的File inspection中点击Localize，选中需要本地化App名称的语言。
    最后在每个语言对应的文件中以key = value(CFBundleDisplayName = "App名称";);的形式设置App的名称。

  
# （二）代码中字符串的本地化

    所谓字符串本地化，就是指App内的字符串在不同的语言环境下显示不同的内容。比如，"主页"这个字符串在中文语言环境下显示“主页”，在英语环境下显示“home”。下面就开始进行字符串本地化。
    其实字符本地化和App名称本地化过程如出一辙，只是创建的文件名成不一样（连同后缀一起，文件名必须是Localizable.strings），其他步骤完全相同。为了能够让大家彻底了解，此处还是会把步骤一一贴出来。

1、和应用名称本地化一样，首先需要command + N，选择iOS -> Resource -> Strings File
2、文件名必须命名为Localizable
3、文件创建成功，查看Xcode左侧导航列表，发现多了一个名为Localizable.strings的文件
4、选中Localizable.strings文件，在Xcode的File inspection中点击Localize，目的是选择我们需要本地化的语言（和本地化App名称同理）
5、然后我们只需要在Localizable.strings下对应的文件中，分别以Key-Value的形式，为代码中每一个需要本地化的字符串赋值
6、我们只需要使用Foundation框架自带的NSLocalizedString(key, comment)这个宏根据Key获取对应的字符串，然后赋值给代码中的字符串。
    // NSLocalizedString(key, comment) 本质
    // NSlocalizeString 第一个参数是内容,根据第一个参数去对应语言的文件中取对应的字符串，第二个参数将会转化为字符串文件里的注释，可以传nil，也可以传空字符串@""。
    #define NSLocalizedString(key, comment) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

################################ 额外总结
# （三）Framework SDK做国际化

1、主要确认bundle路径，其它操作一样
2、bundle路径获取写了个宏，定义如下：
    #define HDLocalString(name)  [[NSBundle bundleForClass:self.class]localizedStringForKey:name value:@"" table:nil]




