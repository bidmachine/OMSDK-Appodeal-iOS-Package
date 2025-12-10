Pod::Spec.new do |spec|
  spec.name                     = "OMSDK_Appodeal"
  spec.version                  = "1.6.0.1"
  spec.summary                  = "Open measure sdk for Appodeal"

  spec.description              = <<-DESC
                                Appodeal's supply-side platform is designed and built by veteran publishers,for publishers. Appodeal is not an ad network; it is a new approach to monetizing for publishers.
                                The platform is a large auction house, accompanied by a mediation layer, that exposes a publisher's inventory to all available buyers on the market via relationships with every major ad network, RTB exchange, and DSP. Appodeal showcases publisher inventory to the advertiser, and offers the highest rate in real time.
                                Appodeal's goal is to cater to the needs of the publisher, not the advertiser, so you always know that you're in good hands.
                                DESC

  spec.homepage                 = "https://bidmachine.io"
  spec.license                  = { :type => 'Commercial', :text => 'https://bidmachine.io/sdk-license-agreement/' }
  spec.author                   = { "Stack" => "https://explorestack.com/bidmachine/" }

  spec.platform                 = :ios, '12.0'
  spec.source                   = { :http => "https://s3-us-west-1.amazonaws.com/appodeal-ios/external-sdks/OMSDK_Appodeal/1.6.0/Pods/OMSDK_Appodeal.zip" }
  spec.frameworks               = "AdSupport"
  spec.default_subspec          = "Dynamic"

  spec.subspec 'Static' do |ss|
    ss.vendored_frameworks      = "Static/OMSDK_Appodeal.xcframework"
  end

  spec.subspec 'Dynamic' do |ss|
    ss.vendored_frameworks      = "Dynamic/OMSDK_Appodeal.xcframework"
  end
end
