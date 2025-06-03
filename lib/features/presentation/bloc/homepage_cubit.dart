import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/presentation/bloc/homepage_state.dart';

class HomepageCubit extends Cubit<HomepageState>{
  HomepageCubit(): super(HomepageInitial());

}