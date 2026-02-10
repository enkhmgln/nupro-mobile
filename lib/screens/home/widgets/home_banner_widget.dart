import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nuPro/library/components/image/io_image_network_widget.dart';
import 'package:nuPro/library/components/main/io_alert.dart';
import 'package:nuPro/library/components/main/io_toast.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/screens/home/model/home_banner_model.dart';

class HomeBannerWidget extends StatefulWidget {
  final List<HomeBannerModel> items;
  final EdgeInsetsGeometry padding;
  const HomeBannerWidget({
    super.key,
    required this.items,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
  });

  @override
  State<HomeBannerWidget> createState() => _HomeBannerWidgetState();
}

class _HomeBannerWidgetState extends State<HomeBannerWidget> {
  final pageController = PageController();
  int current = 1;

  Future<void> _launchUrl(String url) async {
    final result = await const IOAlert(
      type: IOAlertType.warning,
      titleText: 'Вэб хуудас руу шилжих',
      bodyText: 'Та энэ баннер дээр дараад вэб хуудас руу шилжих үү?',
      acceptText: 'Тийм',
      cancelText: 'Үгүй',
    ).show();

    if (result == true) {
      try {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          IOToast(text: 'Вэб хуудас нээх боломжгүй байна').show();
        }
      } catch (e) {
        IOToast(text: 'Вэб хуудас нээхэд алдаа гарлаа').show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: SizedBox(
        height: 140,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    current = index + 1;
                  });
                },
                children: widget.items
                    .map(
                      (e) => GestureDetector(
                        onTap: () => _launchUrl(e.url),
                        child: IOImageNetworkWidget(
                          imageUrl: e.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                    .toList(),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: IOColors.brand900.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '$current/${widget.items.length}',
                    style: IOStyles.caption1Bold.copyWith(
                      color: IOColors.backgroundPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
