import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  required Function() function,
  required String text,
}) =>
    Container(
      width: width,
      height: 40.0,
      child: MaterialButton(
        onPressed: function,
        child: Text( isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );
  Widget defaultTextButton({
  required Function() function,
required String text,
})=>TextButton(
    onPressed: function,
    child: Text(text.toUpperCase()),
  );
Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function(String)? onSubmit,
  Function(String)? onChange,
  Function()? onTap,
  bool isPassword = false,
  required FormFieldValidator validate,
   String? label,
  String? hintText,
  required IconData prefix,

  IconData? suffix,
  Function()? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
       onFieldSubmitted: onSubmit,
      // onChanged: onChange,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        border: const OutlineInputBorder().scale(40.0),
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text(
                '${model['time']}',
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            IconButton(
              onPressed: () {
                // AppCubit.get(context).updateData(
                //   status: 'done',
                //   id: model['id'],
                //);
              },
              icon: Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {
                // AppCubit.get(context).updateData(
                //   status: 'archive',
                //   id: model['id'],
                // );
              },
              icon: Icon(
                Icons.archive,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        // AppCubit.get(context).deleteData(
        //   id: model['id'],
        // );
      },
    );

Widget tasksBuilder({required List<Map> tasks,}) => tasks.length > 0 ? ListView.separated(
            itemBuilder: (context, index) {
              return buildTaskItem(tasks[index], context);
            },
            separatorBuilder: (context, index) => myDivider(),
            itemCount: tasks.length,
          ) : Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu,
                size: 100.0,
                color: Colors.grey,
              ),
              Text(
                'No Tasks Yet, Please Add Some Tasks',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ));
Widget myDivider()=>Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20.0,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);
Widget buildArticleItem(article,context)=>InkWell(
  onTap: (){
 //  navigateTo(context, WebViewScreen(article['url']));
  },
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        Container(

          width: 120.0,

          height: 120.0,

          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(10.0,),

            image: DecorationImage(

              image: NetworkImage('${article['urlToImage']}'),

              fit: BoxFit.cover,

            ),



          ),





        ),

        SizedBox(width: 20.0,),

        Expanded(

          child: Container(

            height: 120.0,

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisAlignment: MainAxisAlignment.start,

              children:[

                Expanded(child:

                Text('${article['title']}',

                  style:Theme.of(context).textTheme.bodyText1,

                  maxLines: 3,

                  overflow: TextOverflow.ellipsis,

                )),

                Text('${article['publishedAt']}',

                  style: TextStyle(

                    color: Colors.grey,

                  ),

                ),

              ],



            ),

          ),

        ),



      ],

    ),

  ),
);
Widget articleBuilder( list,context,{isSearch=false})=>Conditional.single(
  context: context,
  conditionBuilder: (BuildContext context) => list.length>0,
  widgetBuilder: (context) => ListView.separated(
    physics: BouncingScrollPhysics(),
    itemBuilder: (context,index)=>buildArticleItem(list[index],context),
    separatorBuilder: (context,index)=>myDivider(),
    itemCount: 10,),
  fallbackBuilder: (context) => isSearch? Container():Center(child: CircularProgressIndicator()),
);
void navigateTo(context,widget)=>  Navigator.push(context,
  MaterialPageRoute(
      builder: (context)=>widget,
));
void navigateAndFinish(context,widget)=>  Navigator.pushAndRemoveUntil(context,
    MaterialPageRoute(
      builder: (context)=>widget,
    ),
    (Route<dynamic>route)=>false,   //هنا دي بتخليني امسح اللي فات لكن لو عملت ترو هيفضل موجود وكدا كانها زي navigaeTo
);
/*void showToast({
  required String text,
required ToastStates state,
})=>Fluttertoast.showToast(      //دا مكان هيظهر فالاسكرينه يقولي ان الداتا صح واللي تحت هيقول انها غلط
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);*/

void showSnackBar({
  required String text,
  required ToastStates state,  required BuildContext context,
})=> ScaffoldMessenger.of(context).showSnackBar( SnackBar(
    content: Text(text,style: TextStyle(fontSize: 16.0,),),
    duration: Duration(seconds: 5),
    backgroundColor:chooseToastColor(state),
  shape:Border.all(
    color: Colors.white,

  ),

),);

enum ToastStates{SUCCESS,ERROR,WARNING}   //دي بعملها لو عايز استخدم حاجة ليها اكتر من اختيار
Color chooseToastColor(ToastStates state)
{
  Color color;
  switch(state)
  {
    case ToastStates.SUCCESS:
      color=Colors.green;
      break;
    case ToastStates.ERROR:
      color=Colors.red;
      break;
    case ToastStates.WARNING:
      color=Colors.amber;
      break;

  }
  return color;
}
PreferredSizeWidget? defaultAppBar({
  required BuildContext context,
required String title,
List<Widget>?actions,
})=>AppBar(
  leading: IconButton(
    onPressed: (){
      Navigator.pop(context);
    },
    icon: Icon(Icons.arrow_back_ios),
  ),
  title: Text(title),
  titleSpacing: 5.0,
  actions: actions,
);
Widget buildListProduct( model,context,{bool isOldPrice=true,})=>Padding(
  padding: const EdgeInsets.all(20.0),
  child: Container(
    height: 120.0,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image: NetworkImage(model.image),
              width: 120.0,
              height: 120.0,
            ),
            if (model.discount != 0&&isOldPrice)
              Container(
                color: Colors.red,
                child: Text(
                  'DISCOUNT',
                  style: TextStyle(fontSize: 8.0, color: Colors.white),
                ),
              ),
          ],
        ),
        SizedBox(width: 20.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.3,
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    model.price.toString(),
                    style: TextStyle(
                      fontSize: 14.0,
                     // color: defaultColor,
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  if (model.discount != 0&&isOldPrice)
                    Text(
                      model.oldPrice.toString(),
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                       // ShopCubit.get(context).changeFavorites(model.id);
                        //print(model.id);
                      },
                      icon: CircleAvatar(
                        radius: 15.0,
                       // backgroundColor: ShopCubit.get(context).favorites[model.id]==true?defaultColor:Colors.grey,
                        child: Icon(
                          Icons.favorite_border,
                          size: 14.0,
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);