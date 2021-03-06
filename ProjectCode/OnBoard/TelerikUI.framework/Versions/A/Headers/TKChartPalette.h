//
//  TKChartPalette.h
//  TelerikUI
//
//  Copyright (c) 2013 Telerik. All rights reserved.
//

@class TKChartPaletteItem;

/**
 @discussion Represents a palette of palette items. When colors are less than the requested index, the count starts over.
 */
@interface TKChartPalette : NSObject

/**
 Adds a palette item to the palette.
 @param item The item to add.
 */
- (void)addPaletteItem:(TKChartPaletteItem *)item;

/**
 Adds an array of palette items to the palette.
 @param items The items to add.
 */
- (void)addPaletteItems:(NSArray *)items;

/**
 Inserts an item at a specified index.
 @param item The item to insert.
 @param index The index to insert the item at.
 */
- (void)insertPaletteItem:(TKChartPaletteItem *)item atIndex:(NSUInteger)index;

/**
 Replaces an item at a specified index.
 @param item The item to replace with.
 @param index The Index of the item to be replaced.
 */
- (void)replacePaletteItem:(TKChartPaletteItem *)item atIndex:(NSUInteger)index;

/**
 Removes all items from the palette.
 */
- (void)clearPalette;

/**
 Returns a palette item at a specified index.
 @param index The index of the palette item. If this index is bigger than the current items count, the count starts over.
 @return The requested palette item. If there are no items in the palette, returns nil.
 */
- (TKChartPaletteItem *)paletteItemAtIndex:(NSUInteger)index;

/**
 Returns palette items as an immutable array.
 */
- (NSArray *)items;

/**
 Returns the current palette items count.
 */
- (NSUInteger)itemsCount;

@end
