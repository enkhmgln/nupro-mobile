import 'package:g_json/g_json.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/screens/menu/contact/models/contact_social_model.dart';
import 'package:nuPro/screens/menu/contact/models/contact_list_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactController extends IOController {
  final titleText = 'Холбоо барих';
  var profile = ProfileModel.fromJson(JSON.nil);

  final contactList = <ContactListModel>[].obs;
  final info = <ContactSocialModel>[].obs;
  final social = <ContactSocialModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getContact();
  }

  Future getContact() async {
    isInitialLoading.value = true;

    final response = await InfoApi().getContactList();

    if (response.isSuccess) {
      contactList.value = response.data.listValue
          .map((e) => ContactListModel.fromJson(e))
          .toList();
    } else {
      showError(text: response.message);
    }

    setData();

    isInitialLoading.value = false;
  }

  void setData() {
    info.value = [];
    social.value = [];

    for (final contact in contactList) {
      if (contact.fullName.isNotEmpty) {
        info.add(
          ContactSocialModel(
            linkType: ContactSocialType.link,
            icon: 'person',
            name: contact.fullName,
            link: contact.roleName,
          ),
        );
      }

      for (final link in contact.activeLinks) {
        if (link.isActive && link.url.isNotEmpty) {
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

          social.add(
            ContactSocialModel(
              linkType: ContactSocialType.link,
              icon: icon,
              name: link.title,
              link: link.url,
            ),
          );
        }
      }
    }
  }

  void onTapAction(ContactSocialModel item) {
    switch (item.linkType) {
      case ContactSocialType.phone:
        onCallToPhone(item.link);
        break;
      case ContactSocialType.mail:
        onSendToMail(item.link);
        break;
      case ContactSocialType.link:
        onOpenToLink(item.link);
        break;
    }
  }

  Future onCallToPhone(String value) async {
    final Uri callLaunchUri = Uri(scheme: 'tel', path: value);
    await launchUrl(callLaunchUri);
  }

  Future onOpenToLink(String value) async {
    if (await canLaunchUrlString(value)) {
      await launchUrlString(
        value,
        mode: LaunchMode.externalApplication,
      );
    } else {
      showError(text: 'Хуудас нээхэд алдаа гарлаа');
    }
  }

  Future onSendToMail(String value) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: value,
      query: encodeQueryParameters(<String, String>{'subject': ''}),
    );
    await launchUrl(emailLaunchUri);
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
