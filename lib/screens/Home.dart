
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:udemy/models/transaction.dart';
import 'package:udemy/widgets/chart.dart';
import 'package:udemy/widgets/new_transaction.dart';
import 'package:udemy/widgets/transaction_list.dart';



class Home extends StatefulWidget {
  
  //String titleInput;
  //String amountInput;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  final List<Transaction> _userTransactions = [
  // Transaction(
  //     id: 't1',
  //     title:'Pen', 
  //     amount: 40.4, 
  //     date: DateTime.now()
  //     ),
  //     Transaction(
  //     id: 't1',
  //     title:'Mobile', 
  //     amount: 35.40, 
  //     date: DateTime.now()
  //     ),
];
  bool _showChart = false;
  List<Transaction> get _recentTransactions{
    return _userTransactions.where((tx){
      return tx.date.isAfter(
        DateTime.now().subtract(Duration(days: 7),
        ),
      );

    }).toList();

  }

  void _addNewTransaction(String txTitle,double txAmount,DateTime chosenDate){
    final newTx=Transaction(
      id: DateTime.now().toString(), 
      title: txTitle, 
      amount: txAmount, 
      date: chosenDate,
      );
      setState(() {
        _userTransactions.add(newTx);
      });
  }


  

  void _startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(context: ctx, builder: (_){
      return GestureDetector(
        onTap: (){},
        child: NewTransaction(_addNewTransaction),
        behavior: HitTestBehavior.opaque,
        );
    },);
  
  }

    void _deleteTransaction( String id){
      setState(() {
        _userTransactions.removeWhere((tx) {
            return tx.id == id;
        });
      });
    }
   
  @override
  Widget build(BuildContext context) {
    final isLandScape = MediaQuery.of(context).orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS 
    ? CupertinoNavigationBar(
      middle: Text(
        'Personal Expenses',
      ),
      trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
      icon: Icon(CupertinoIcons.add ), 
      onPressed: () => _startAddNewTransaction(context),
            ),
          ],
        ),
    )
    :AppBar(
        title:Text('Personal Expenses'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add), 
            onPressed: () => _startAddNewTransaction(context),
          ),
        ],
      );
      final txListWidget = Container(
            height: (MediaQuery.of(context).size.height-appBar.preferredSize.height-MediaQuery.of(context).padding.top)*0.7,
            child: TransactionList(_userTransactions,_deleteTransaction)
            );
      final pageBody = SafeArea(
            child:SingleChildScrollView(
                  child: Column(
           // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if ( isLandScape ) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Show Chart',
                style:Theme.of(context).textTheme.headline6 ,
                ),
                Switch.adaptive(value:_showChart, 
                onChanged:(val){
                  setState(() {
                    _showChart= val;

                  });
                }),
              ],
            ),
              if(!isLandScape) Container(
              height: (
                MediaQuery.of(context).size.height-appBar.preferredSize.height-MediaQuery.of(context).padding.top)*0.3,
              child: Chart(_recentTransactions)
              ),

              if(!isLandScape) txListWidget,

              if(isLandScape) _showChart ?Container(
              height: (MediaQuery.of(context).size.height-appBar.preferredSize.height-MediaQuery.of(context).padding.top)*0.7,
              child: Chart(_recentTransactions)
              )
              :txListWidget

          ],
      ),
        ),
      );
    return Platform.isIOS?CupertinoPageScaffold(child: pageBody,navigationBar: appBar,) 
    : Scaffold(
  
      appBar: appBar,
      
        body: pageBody, 
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Platform.isIOS?Container()
        :FloatingActionButton(
          onPressed:  () => _startAddNewTransaction(context),
          child:Icon(Icons.add)
          ),

      );

    
  }
}
