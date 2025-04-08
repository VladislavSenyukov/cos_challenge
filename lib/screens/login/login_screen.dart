import 'package:auto_route/auto_route.dart';
import 'package:cos_challenge/router.gr.dart';
import 'package:cos_challenge/screens/login/login_screen_bloc.dart';
import 'package:cos_challenge/utils/app_spinner.dart';
import 'package:cos_challenge/utils/helpers.dart';
import 'package:cos_challenge/utils/image_keys.dart';
import 'package:cos_challenge/utils/text_field_area.dart';
import 'package:cos_challenge/utils/theme.dart';
import 'package:cos_challenge/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => LoginScreenBloc(),
    child: BlocConsumer<LoginScreenBloc, LoginScreenState>(
      builder:
          (context, state) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: AppColor.blackMineShaft,
              body: _buildScreenContent(context: context, state: state),
            ),
          ),
      listener:
          (context, state) => state.event?.takeContent()?.also(
            (event) => switch (event) {
              LoginScreenEventOnLoginSuccessful() => context.router.push(
                VinSearchRoute(),
              ),
              LoginScreenEventFocusTextField() =>
                FocusScope.of(context).nextFocus(),
            },
          ),
    ),
  );

  Widget _buildScreenContent({
    required BuildContext context,
    required LoginScreenState state,
  }) => SingleChildScrollView(
    child: SizedBox(
      width: screenSize(context).width,
      height: screenSize(context).height,
      child: Column(
        children: [
          Spacer(flex: 2),
          SvgPicture.asset(SvgKey.cosLogo, height: 150),
          Spacer(flex: 2),
          TextFieldArea(
            text: 'Enter your user ID:',
            textController: state.textController,
            onSubmitted: context.read<LoginScreenBloc>().loginWithUserId,
          ),
          Spacer(),
          AppSpinner(isLoading: state.isLoading),
          Spacer(),
        ],
      ),
    ),
  );
}
