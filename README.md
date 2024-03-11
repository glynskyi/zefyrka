*Soft and gentle rich text editing for Flutter applications.*

Zefyrka is a fork of Zefyr package with the following improvements:

- support Flutter 2.0
- opt-in the null safety
- added the extended attributes:
    * text color
    * background color
    * paragraph alignment
    * paragraph indentation

For documentation see [https://github.com/gkynskyi/zefyrka](https://github.com/glynskyi/zefyrka).

<img alt="zefyrka screenshot" src="https://github.com/glynskyi/zefyrka/raw/main/assets/zefyr-1.png" width="400">

## Usage

See the `example` directory for a minimal example of how to use Zefyrka. You typically just need to instantiate a controller:

```
ZefyrController _controller = ZefyrController();
```

and then embed the toolbar and the editor, within your app.  For example:

```dart
Column(
  children: [
    ZefyrToolbar.basic(controller: _controller),
    Expanded(
      child: ZefyrEditor(
        controller: _controller,
      ),
    ),
  ],
)
```

Check out [Sample Page] for advanced usage.

## Installation

Official releases of Zefyrka can be installed from Dart's Pub package repository.

> Note that versions from Pub track stable channel of Flutter.

To install Zefyrka from Pub add `zefyrka` package as a dependency to your `pubspec.yaml`:

```yaml
dependencies:
  zefyrka: [latest_version]
```

And run `flutter packages get`.

Continue to [https://github.com/glynskyi/zefyrka/blob/main/doc/quick-start.md](documentation) to
learn more about Zefyrka and how to use it in your projects.

[Sample Page]: https://github.com/glynskyi/zefyrka/blob/master/example/lib/src/home.dart
