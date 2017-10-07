# segmentedControl
一个自定义的segmented Control

#features :

#1.下方蓝色指示条随页面的滑动而移动

#2.上面的字体颜色随着滑动渐变

usage:

```
        titleSegmentControl = GUTabControl(frame: CGRect(x: 0, y: 0, width: 140, height: 44));
        titleSegmentControl?.selectedColor = UIColor.fromHex(rgbValue: 0x00C2DE)
        titleSegmentControl?.indicatorColor = UIColor.fromHex(rgbValue: 0x00C2DE)
        titleSegmentControl?.titles = ["发现","对话"]
        titleSegmentControl?.currentPage = 1
        titleSegmentControl?.addTarget(self, action: #selector(titleViewValueChanged(sender:)), for: .valueChanged)
        self.navigationItem.titleView = titleSegmentControl
```
[![watch the video](https://github.com/sidetlw/segmentedControl/blob/master/1.gif)]
