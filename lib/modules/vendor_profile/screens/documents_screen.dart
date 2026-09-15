import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/app_status_chip.dart';
import '../../../shared/widgets/main_layout.dart';
import '../controllers/vendor_profile_controller.dart';

class DocumentsScreen extends GetView<VendorProfileController> {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Verification & KYC Documents',
      body: Obx(() {
        final p = controller.profile.value;
        if (p == null) return const AppLoader();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                title: 'Uploaded Documents',
                subtitle: 'Government recognized identity & tourism credentials',
                trailing: AppButton(
                  text: '+ Upload Document',
                  icon: Icons.upload_file_rounded,
                  height: AppDimensions.buttonHeightSm,
                  onPressed: () {
                    Get.snackbar('Upload', 'Select a file to upload verification document');
                  },
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: p.documents.length,
                  separatorBuilder: (_, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final doc = p.documents[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.picture_as_pdf_outlined, color: Colors.redAccent, size: 28),
                          const SizedBox(width: AppDimensions.spaceMd),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(doc.documentType, style: AppTextStyles.h4),
                                const SizedBox(height: 2),
                                Text(
                                  'Ref: ${doc.documentNumber} • Uploaded on ${Formatters.date(doc.uploadedAt)}',
                                  style: AppTextStyles.caption,
                                ),
                              ],
                            ),
                          ),
                          AppStatusChip(status: doc.verificationStatus),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
