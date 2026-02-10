class OnboardingModel {
  final String title;
  final String description;
  final String? buttonText;

  OnboardingModel({
    required this.title,
    required this.description,
    this.buttonText,
  });
}

class OnboardingData {
  static List<OnboardingModel> get onboardingPages => [
        OnboardingModel(
          title: 'Мэргэжлийн сувилагч, шуурхай үйлчилгээ',
          description:
              'Манай аппликэйшнд тавтай морилно уу, Бид дуудлагын сувилагчийн үйлчилгээний шинэ түүхийг бүтээж, чанар хүртээмжийг дээдлэн харилцааг эрхэмлэнэ.',
        ),
        OnboardingModel(
          title: 'Шуурхай үйлчилгээ',
          description:
              'Бид таны эрүүл мэндийг анхаарахын тулд хамгийн мэргэжлийн сувилагчдыг танд хүргэхээр бэлтгэсэн.',
        ),
        OnboardingModel(
          title: '24/7 Дэмжлэг',
          description:
              'Бид танд хэрэгтэй үедээ үргэлж бэлэн байх болно. Дуудлага хийж, мэргэжлийн тусламж аваарай.',
        ),
      ];
}
