import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/customer_bloc.dart';
import '../widgets/customer_form.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CustomerBloc>();

    return Scaffold(
      appBar: AppBar(title: Text('Customeri')),
      body: BlocBuilder<CustomerBloc, CustomerState>(
        builder: (context, state) {
          if (state is CustomerLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CustomerLoaded) {
            return ListView.builder(
              itemCount: state.customers.length,
              itemBuilder: (_, i) {
                final c = state.customers[i];
                return ListTile(
                  title: Text(c.name),
                  subtitle: Text(c.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: Icon(Icons.edit), onPressed: () {
                        showDialog(context: context, builder: (_) => CustomerForm(customer: c));
                      }),
                      IconButton(icon: Icon(Icons.delete), onPressed: () {
                        bloc.add(DeleteCustomer(c.id));
                      }),
                    ],
                  ),
                );
              },
            );
          }
          return Center(child: Text('Errore'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (_) => CustomerForm());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
