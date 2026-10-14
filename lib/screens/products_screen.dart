import 'package:fintech_mobile_application/repositories/savings_repository.dart';
import 'package:fintech_mobile_application/screens/savings_details_screen.dart';
import 'package:fintech_mobile_application/utils/size_config.dart';
import 'package:fintech_mobile_application/widgets/app_text.dart';
import 'package:fintech_mobile_application/widgets/async_state_widgets.dart';
import 'package:fintech_mobile_application/widgets/product_card.dart';
import 'package:flutter/material.dart';

enum ProductFilter { all, highInterest, flexible }

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _searchController = TextEditingController();
  ProductFilter _filter = ProductFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final products = SavingsRepository.products.where((product) {
      final matchesSearch =
          product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);
      final matchesFilter = switch (_filter) {
        ProductFilter.all => true,
        ProductFilter.highInterest => product.interestRate >= 10,
        ProductFilter.flexible => product.duration == 'Flexible',
      };
      return matchesSearch && matchesFilter;
    }).toList();

    return ListView(
      padding: EdgeInsets.fromLTRB(
        SizeConfig.pagePadding,
        8.responsiveSize,
        SizeConfig.pagePadding,
        32.responsiveSize,
      ),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: SizeConfig.contentMaxWidth(
                SizeConfig.wideContentMaxWidth,
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final useGrid =
                    constraints.maxWidth >= SizeConfig.twoColumnBreakpoint;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hint: AppText(
                          text: 'Search savings products',
                          type: AppTextType.bodyMedium,
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    SizedBox(height: 12.responsiveSize),
                    _ProductFilters(
                      selected: _filter,
                      expand: constraints.maxWidth >= 500,
                      onChanged: (value) => setState(() => _filter = value),
                    ),
                    SizedBox(height: 18.responsiveSize),
                    if (products.isEmpty)
                      const EmptyState(
                        message: 'No savings products match your search.',
                      )
                    else if (!useGrid)
                      ...products.map(
                        (product) => Padding(
                          padding: EdgeInsets.only(bottom: 12.responsiveSize),
                          child: ProductCard(
                            product: product,
                            onView: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    SavingsDetailsScreen(product: product),
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              mainAxisExtent: 236,
                            ),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductCard(
                            product: product,
                            onView: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    SavingsDetailsScreen(product: product),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductFilters extends StatelessWidget {
  const _ProductFilters({
    required this.selected,
    required this.expand,
    required this.onChanged,
  });

  final ProductFilter selected;
  final bool expand;
  final ValueChanged<ProductFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final filters = SegmentedButton<ProductFilter>(
      expandedInsets: expand ? EdgeInsets.zero : null,
      segments: const [
        ButtonSegment(
          value: ProductFilter.all,
          label: AppText(text: 'All', type: AppTextType.labelLarge),
        ),
        ButtonSegment(
          value: ProductFilter.highInterest,
          label: AppText(text: '10%+ Interest', type: AppTextType.labelLarge),
        ),
        ButtonSegment(
          value: ProductFilter.flexible,
          label: AppText(text: 'Flexible', type: AppTextType.labelLarge),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (value) => onChanged(value.first),
    );

    if (expand) return filters;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: filters,
    );
  }
}
