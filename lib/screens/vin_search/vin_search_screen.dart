import 'package:auto_route/auto_route.dart';
import 'package:cos_challenge/core/network_models.dart';
import 'package:cos_challenge/screens/vin_search/vin_search_screen_bloc.dart';
import 'package:cos_challenge/utils/app_spinner.dart';
import 'package:cos_challenge/utils/helpers.dart';
import 'package:cos_challenge/utils/text_field_area.dart';
import 'package:cos_challenge/utils/theme.dart';
import 'package:cos_challenge/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class VinSearchScreen extends StatelessWidget {
  const VinSearchScreen({super.key});

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    child: BlocProvider(
      create: (_) => VinSearchScreenBloc(),
      child: BlocConsumer<VinSearchScreenBloc, VinSearchScreenState>(
        builder:
            (context, state) => GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                body: _buildScreenContent(context: context, state: state),
                extendBodyBehindAppBar: false,
                backgroundColor: AppColor.grayTrout,
              ),
            ),
        listener:
            (context, state) => state.event?.takeContent()?.also(
              (event) => switch (event) {
                VinSearchScreenEventOnLogout() => context.pop(),
                VinSearchScreenEventError() => showNotification(
                  event.error.text,
                ),
                VinSearchScreenEventShowVinChoices() => _showVinChoicesPopup(
                  context: context,
                  vinChoices: event.vinChoices,
                ),
              },
            ),
      ),
    ),
  );

  Widget _buildScreenContent({
    required BuildContext context,
    required VinSearchScreenState state,
  }) => SingleChildScrollView(
    child: SizedBox(
      width: screenSize(context).width,
      height: screenSize(context).height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Spacer(),
          _buildLogoutArea(context: context, userId: state.userId),
          Spacer(),
          TextFieldArea(
            text: 'Enter VIN:',
            textController: state.textController,
            onSubmitted: context.read<VinSearchScreenBloc>().onVinEntered,
          ),
          SizedBox(height: 20),
          _buildVinInfoArea(context: context, state: state),
          Spacer(flex: 2),
        ],
      ),
    ),
  );

  Widget _buildLogoutArea({
    required BuildContext context,
    required String? userId,
  }) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      if (userId != null)
        Text(
          'User id: $userId',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColor.white,
          ),
        ),
      IconButton(
        onPressed: context.read<VinSearchScreenBloc>().logout,
        icon: Icon(Icons.logout, color: AppColor.white),
      ),
      SizedBox(width: screenWidthPortion(context, 0.05)),
    ],
  );

  Widget _buildVinInfoArea({
    required BuildContext context,
    required VinSearchScreenState state,
  }) => AnimatedSize(
    duration: Duration(milliseconds: 250),
    curve: Curves.easeInOut,
    child:
        state.vinData != null
            ? Container(
              width: screenWidthPortion(context, 0.9),
              height: screenHeightPortion(context, 0.4),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    state.vinData!.descriptionText,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            )
            : AppSpinner(isLoading: state.isLoading),
  );

  void _showVinChoicesPopup({
    required BuildContext context,
    required List<VinData> vinChoices,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: AppColor.blackMineShaft.withAlpha(204),
      builder:
          (_) => Center(
            child: Container(
              width: screenWidthPortion(context, 0.8),
              height: screenHeightPortion(context, 0.7),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    elevation: 4.0,
                    color: AppColor.yellowCreamCan,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      child: Text(
                        'Here\'s some VINs that meet your request sorted by similarity:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColor.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: vinChoices.length,
                      itemBuilder:
                          (_, index) => Material(
                            color: AppColor.white,
                            elevation: 4.0,
                            child: ListTile(
                              title: Text(
                                vinChoices[index].choiceText,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                context
                                    .read<VinSearchScreenBloc>()
                                    .onVinChoiceSelected(vinChoices[index]);
                                Navigator.of(context).pop();
                              },
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

extension VinSearchScreenErrorHelper on VinSearchScreenError {
  String get text {
    final error = this;
    return switch (error) {
      VinSearchScreenErrorAuth() =>
        'Authorization error, please relogin and try again.',
      VinSearchScreenErrorTimeout() =>
        'Timeout error, please check your network connection and try again.',
      VinSearchScreenErrorParser() =>
        'Error occured when parsing data from the server. Please, contact your administrator.\n${error.message}',
      VinSearchScreenErrorNotFound() =>
        'VIN is not found. Please, check the input and try again.',
      VinSearchScreenErrorUnknown() => 'Unknown error:\n${error.message}',
    };
  }
}

extension VinDataHelper on VinData {
  String get choiceText => [
    if (make != null) make,
    if (model != null) model,
    if (containerName != null) containerName,
    'similarity: ${similarity ?? 0}',
  ].join(', ');

  String get descriptionText => [
    'Price: ${price ?? 0}',
    'Make: ${make ?? ''}',
    'Model: ${model ?? ''}',
    'Auction UUID: ${auctionUuid ?? ''}',
    if (positiveCustomerFeedback != null)
      positiveCustomerFeedback!
          ? 'Positive feedback 👍'
          : 'Negative feedback 👎',
  ].join('\n');
}
