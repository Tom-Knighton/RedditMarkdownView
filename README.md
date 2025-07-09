# RedditMarkdownView
A SwiftUI library to parse and render Reddit's Snudown markdown scheme, 
with spoilers and table support (and all of reddit's quirks)

![img](https://cdn.tomk.online/cdn/RedditMarkdownView/presentation1.png)

# Features
- Parse any plain text into Reddit's Snudown and have it automatically 
rendered for you ✨
- Uses a custom version of Reddit's Snudown package, so the library 
automatically handles:
  - Headers
  - Tables
  - Spoilers
  - Lists
  - Quotes
  - Code blocks
  - Code highlighting with Highlightr
  - Inline images with Nuke
  - Automatic u/username and r/reddit links
  - And everything else on reddit's page here
- Easily customisable

# How to use

## Install:
This library is provided through SPM, you can add the following URL to 
your project dependencies:
`https://github.com/Tom-Knighton/RedditMarkdownView.git`

## Simple:
Simply render the Snudown view somewhere in your code:

```swift
var body: some View {
  ScrollView {
    SnudownView("Hey this is some markdown!\n#I'm a header\n\n>!spoiler 
>:)!<")
  }
}
```
Note: It's recommended to wrap the SnudownView in a vertical scroll view

## Custom:
You can customise most of the SnudownView's display features, for example 
the following view modifiers are available:
- `.snudownConfig(_ config: SnudownConfig)`
- `.snudownTableAvgWidth(_ width: CGFloat)`
- `.snudownTextAlignment(_ alignment: Alignment)`
- `.snudownMultilineAlignment(_ alignment: TextAlignment)`
- `.snudownFont(for fontLevel: SnudownFontFor, _ font: Font)`
- `.snudownTextColor(_ color: Color)`
- `.snudownLinkColor(_ color: Color)`
- `.snudownDisplayInlineImages(_ display: Bool)`
- `.snudownInlineImageWidth(_ width: CGFloat)`
- `.snudownMaxCharacters(_ maxCharacters: Int?)`

Each of these pretty much do what they say, but some small additional 
built-in documentation is available on each method 

### Larger tables
In some cases, you may want to display tables with larger average column 
widths than default (The default is `150`).You can provide the average 
column width for tables, the reason it's an 'average' is because the Grid 
view needs a fixed width, and the width is calculated from the average 
column width multiplied by the number of columns. So if the average width 
is set to `100`, and there are 5 columns, the entire width of the grid 
will be `500`, and some columns may shrink if they can and if other 
columns want to take up more space.

Snudown tables are wrapped in a horizontal scrollview, so they can exceed 
the width of the window.

```swift
var body: some View {
  ScrollView {
    SnudownView(text: "|Column 1|Column 2|Column 3 which is 
big|\n|-|-|-|\n|text|text|Lorem ipsum dolor sit amet, consectetur 
adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore 
magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco 
laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in 
reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla 
pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa 
qui officia deserunt mollit anim id est laborum.|")
    .snudownTableAvgWidth(250)
  }
}
```

![img](https://cdn.tomk.online/cdn/RedditMarkdownView/presentation2.png)

## Inline images
By default Snudown uses Nuke to analyse links (including plain text links) 
and display inline images if the link is a direct link to an image. 
Because of how adding inline images works, combined with keeping the 
package lightweight, the images are loaded and resized to a fixed size 
(defaults to `50` width)

You can toggle displaying inline images at all (when false the links will 
still be present and tappable), and the width the images will be resized 
to in either the `SnudownConfig` model or by using the separate view 
modifiers
`.snudownDisplayInlineImages(_ display: Bool)` 
`.snudownInlineImageWidth(_ width: CGFloat)`

For example:
```swift
SnudownView(text: "[imageception](https://upload.wikimedia.org/wikipedia/commons/b/be/SGI-2016-South_Georgia_%28Fortuna_Bay%29%E2%80%93King_penguin_%28Aptenodytes_patagonicus%29_04.jpg)"
```
![img](https://cdn.tomk.online/cdn/RedditMarkdownView/presentation3.png)

## u/ and r/ links
The library uses a slightly (2 lines!) modified version of Snudown, which 
by default detects u/ and r/ links, the modifications allow capital U and 
capital R to also be detected. These are formatted as links, and direct to 
https://reddit.com/r/.... and /u/...

## Spoilers
Because the library uses Snudown directly, we can parse spoilers as 
tappable views, that reveal their contents only once tapped. Spoilers are 
written in markdown as 
`>!spoiler text goes here...!<`

## Code blocks
You can write code in markdown as either a single line surrounded by 
backticks (`)

 or multiline, surrounded by three backticks (`\``)

If you have a multiline code block, you can write the language after the 
top backticks like so:
```
```swift 
code here...
````
The library uses Highlightr to highlight syntax, and provides a copy 
button to copy the text to the clipboard.


# Notes
- I wrote this library over a weekend as I wanted to parse Reddit's 
flavour of markdown rather than use Swift's implementation of cmark with 
spoilers and tables and such hacked into it, and I wrote it for me, so if 
anyone wants to contribute to enforce standards, or in any way make it 
better please do :)
- This should pretty much handle everything Reddit can, there's a little 
bit of manual work needed to convert the resulting html like results from 
snudown to SwiftUI views, so if anything is missed raise an issue or a PR
- It does use Nuke, SwiftSoup and Highlightr, if these can be 
replaced/removed that would be great if anyone knows ways to replace their 
functionality easily
- I originally used [LiYanan2004's 
MarkdownView](https://github.com/LiYanan2004/MarkdownView) library to 
handle Cmark markdown into SwiftUI views, and a lot of this library is 
based on recreating the look and feel, so massive credit to LiYanan for 
the designs of views (particularly tables)
- The library uses [ksemianov's 
WrappingHStack](https://github.com/ksemianov/WrappingHStack) to display 
text and spoilers etc next to eachother

# License:
This library is provided under MIT license

