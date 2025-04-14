import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/src/constants/app_colors.dart';
import 'package:weather_app/src/core/locator.dart';
import 'package:weather_app/src/features/home_page/presentation/bloc/home_bloc.dart';
import 'package:weather_app/src/features/home_page/presentation/screens/bloc/settings_bloc.dart';
import 'package:weather_app/src/services/navigation_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return _SettingsPageView();
  }
}

Map<String, String> windUnits = {
  'km/h': 'km/h',
  'ms': 'm/s',
  'mph': 'mph',
  'knots': 'kn',
};
Map<String, String> temperatureUnits = {
  'Celsius': 'Celsius',
  'Fahrenheit': 'Fahrenheit',
};
Map<String, String> precipitationUnits = {
  'Millimeter': 'Millimeter',
  'Inch': 'Inch',
};

class _SettingsPageView extends StatelessWidget {
  _SettingsPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
        title: Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is SettingsLoaded) {
            return _buildSettingsList(context, state);
          } else {
            return Center(child: Text('Failed to load settings'));
          }
        },
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context, SettingsLoaded state) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      children: [
        _buildSectionHeader('Temperature Units'),
        _buildUnitSelector(
          context: context,
          title: 'Temperature',
          options: ['Celcius', 'Fahrenheit'],
          currentValue: state.temperatureUnit,
          onChanged: (value) {
            context.read<SettingsBloc>().add(UpdateTemperatureUnitEvent(value));
          },
        ),
        Divider(),
        _buildSectionHeader('Precipitation Units'),
        _buildUnitSelector(
          context: context,
          title: 'Precipitation',
          options: ['Millimeter', 'Inch'],
          currentValue: state.precipitationUnit,
          onChanged: (value) {
            context.read<SettingsBloc>().add(
              UpdatePrecipitationUnitEvent(value),
            );
          },
        ),
        Divider(),
        _buildSectionHeader('Wind Speed Units'),
        _buildUnitSelector(
          context: context,
          title: 'Wind Speed',
          options: windUnits.keys.toList(),

          currentValue: state.windSpeedUnit,
          onChanged: (value) {
            context.read<SettingsBloc>().add(UpdateWindSpeedUnitEvent(value));
          },
        ),
        Divider(),
        _buildSectionHeader('Other Units'),
        _buildInfoCard(
          title: 'UV Index',
          description:
              'UV Index is always displayed as a unitless value from 0-11+',
        ),
        SizedBox(height: 8.h),
        _buildInfoCard(
          title: 'Cloud Cover',
          description: 'Cloud cover is always displayed as a percentage (%)',
        ),
        SizedBox(height: 16.h),
        _buildApplyButton(context),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.appGreen,
        ),
      ),
    );
  }

  Widget _buildUnitSelector({
    required BuildContext context,
    required String title,
    required List<String> options,
    required String currentValue,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: currentValue,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 16,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                onChanged: (String? value) {
                  if (value != null) {
                    onChanged(value);
                  }
                },
                items:
                    options.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String description}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4.h),
          Text(
            description,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.appGreen,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 50.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        onPressed: () {
          // Save settings
          context.read<SettingsBloc>().add(SaveSettingsEvent());

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Settings saved'),
              backgroundColor: AppColors.appGreen,
            ),
          );

          locator<INavigationService>().back(true);
        },
        child: Text(
          'Apply Changes',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
