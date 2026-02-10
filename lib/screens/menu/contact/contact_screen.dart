import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/components/main/io_appbar.dart';
import 'package:nuPro/library/components/main/io_loading.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/screens/menu/contact/contact_controller.dart';
import 'package:nuPro/screens/menu/contact/models/contact_social_model.dart';
import 'package:nuPro/screens/menu/contact/widgets/contact_section_widget.dart';
import 'package:nuPro/screens/menu/contact/widgets/contact_social_widget.dart';

class ContactScreen extends GetView<ContactController> {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IOScaffold(
      appBar: IOAppBar(
        titleText: controller.titleText,
      ),
      body: Obx(
        () => controller.isInitialLoading.value
            ? const IOLoading()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...controller.contactList.map((contact) => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 8),
                            ContactSectionWidget(
                              title: contact.fullName,
                            ),
                            ContactSocialWidget(
                              items: [
                                ContactSocialModel(
                                  linkType: ContactSocialType.link,
                                  icon: 'person',
                                  name: contact.roleName,
                                  link: 'Албан тушаал',
                                ),
                                ...contact.activeLinks
                                    .where((link) =>
                                        link.isActive && link.url.isNotEmpty)
                                    .map((link) {
                                  String icon = 'link';
                                  switch (link.linkType) {
                                    case 'web':
                                      icon = 'language';
                                      break;
                                    case 'social':
                                      icon = 'share';
                                      break;
                                    case 'other':
                                      icon = 'link';
                                      break;
                                    default:
                                      icon = 'link';
                                      break;
                                  }
                                  return ContactSocialModel(
                                    linkType: ContactSocialType.link,
                                    icon: icon,
                                    name: link.title,
                                    link: link.url,
                                  );
                                }),
                              ],
                              onTap: controller.onTapAction,
                            ),
                          ],
                        )),
                  ],
                ),
              ),
      ),
    );
  }
}
