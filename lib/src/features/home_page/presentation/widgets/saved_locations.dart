import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/src/constants/app_colors.dart';
import 'package:weather_app/src/features/home_page/domain/models/location.dart';
import 'package:weather_app/src/features/home_page/presentation/cubit/saved_locations_cubit.dart';

class SavedLocationsSheet extends StatelessWidget {
  const SavedLocationsSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedLocationsCubit, SavedLocationsState>(
      builder: (context, state) {
        final locations =
            state is SavedLocationsLoaded ? state.locations : <SavedLocation>[];

        return Container(
          padding: EdgeInsets.only(
            top: 16.h,
            left: 16.w,
            right: 16.w,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Saved Locations',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              if (state is SavedLocationsLoading)
                const Center(child: CircularProgressIndicator())
              else if (state is SavedLocationsError)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Text(
                      state.message,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else if (locations.isEmpty)
                _buildEmptyState()
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: locations.length,
                    itemBuilder: (context, index) {
                      final location = locations[index];
                      return _locationItem(context, location);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bookmark_border, size: 48.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'No saved locations yet',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your saved locations will appear here',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _locationItem(BuildContext context, SavedLocation location) {
    return Dismissible(
      key: Key('${location.latitude}_${location.longitude}'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red[400],
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.w),
        child: Icon(Icons.delete, color: Colors.white, size: 32.sp),
      ),
      onDismissed: (direction) {
        context.read<SavedLocationsCubit>().deleteLocation(location);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location removed from saved locations'),
            backgroundColor: Colors.red[400],
            action: SnackBarAction(
              label: 'UNDO',
              textColor: Colors.white,
              onPressed: () {
                context.read<SavedLocationsCubit>().saveLocation(location);
              },
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 8.h),
        child: InkWell(
          onTap: () => Navigator.pop(context, location),
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Icon(Icons.location_on, color: AppColors.appGreen, size: 24.sp),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (location.country != null)
                        Text(
                          location.country!,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red[400],
                    size: 22.sp,
                  ),
                  onPressed: () {
                    context.read<SavedLocationsCubit>().deleteLocation(
                      location,
                    );
                    // Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
