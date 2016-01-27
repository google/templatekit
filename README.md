#TemplateKit

*This software is still in alpha. Backward-incompatible changes will
be made without notice.*

TemplateKit is a framework for iOS view programming. Its goal is to
become a default tool for implementing complex custom views with
abstractions optimized for the most common cases.

TemplateKit provides an intuitive and efficient DSL to perform common
tasks in view programming such as view hierarchy construction, data
population, and layout. View code written with TemplateKit is much
shorter and more readable than code written with the raw UIView API.

For example, to implement a classic table view cell with an image on
the left and two stacked texts on the right like this:

<img src="https://github.com/google/templatekit/blob/master/ExampleView.png" align="left" height="60" width="208" /><br><br><br>

you would just write:

    // From SampleApp/Templates/FirstExample.m.
    
    TPL_DEFINE_VIEW_TEMPLATE(first_example, FirstExampleView) {
      return row(image($(thumbnail)),
                 margin(@10),
                 column(label($(title)),
                        label($(subtitle)),
                        nil),
                 nil)
               .padding(TPLEdgeInsetsMake(10, 10, 10, 10));
    }

These seven lines of template code in the block is enough to tell the framework to
construct a view hierarchy with one UIImageView instance and two UILabel instances,
populate them with runtime data, and lay out the view hierarchy with the specified
margin and paddings. Even a very simple view like this would take several dozens of
lines if it were implemented with the raw UIView API.

##Usage
Find examples in SampleApp/Templates.

##Discussion Forum
https://groups.google.com/forum/#!forum/templatekit

##Disclaimer
This is not an official Google product.
