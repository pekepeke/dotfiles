### 独自クエリの発行

```php
<?php
$found_posts = get_posts('numberposts=5&orderby=post_date&order=DESC"');
foreach ($found_posts as $post) : setup_postdata($post);
?>
<li><?php the_date(); ?><a href="<?php the_permalink();?>"><?php the_title(); ?></a>
</li>
<?php endforeach; ?>
```

#### taxonomy

```
$args = array(
  'numberposts' => 3,
  'orderby'     => 'post_date',
  'order'       => 'DESC',
	'tax_query' => array(array(
		'taxonomy' => 'genre',
		'field' => 'slug',
		'terms' => 'jazz'
	)),
);
get_posts($args);
```

#### custom field

```
$args = array(
	'post_type' => 'product',
	'meta_query' => array(
		array(
			'key' => 'featured',
			'value' => 'yes',
		)
	)
 );
$postslist = get_posts( $args );
```

### json のレスポンス

```php
$args = array(
  'numberposts' => 3,
  'orderby'     => 'post_date',
  'order'       => 'DESC',
);
$posts = get_posts($args);

if($posts): foreach($posts as $post):
  setup_postdata($post);
  $json[] = $post;
endforeach; endif;

if (isset($_GET["callback"])) {
	header("Content-Type: application/javascript; charset=utf-8");
	echo sprintf("%s(%s)", $_GET["callback"], json_encode($json));
} else {
	header("Content-Type: application/json; charset=utf-8");
	echo json_encode($json);
}
```

### p を消す

```php
<?php
/*
 * Template Name: XXX
 */
get_header(); ?>

		<?php
		// Start the loop.
		while ( have_posts() ) : the_post();
			remove_filter('the_content', 'wpautop');
			the_content();
		// End the loop.
		endwhile;
		?>

<?php get_footer(); ?>
```

### テンプレートの優先順位

| ページの種類                 | 高                             |           ←            | テンプレート階層優先度  |      →        |        低 |
|------------------------------|--------------------------------|-------------------------|-------------------------|----------------|-----------|
| 404エラーページ              |                                |                         |                         | 404.php        | index.php |
| 検索結果ページ               |                                |                         |                         | search.php     | index.php |
| カスタム分類アーカイブ       | taxonomy-{taxonomy}-{term}.php | taxonomy-{taxonomy}.php | taxonomy.php            | archive.php    | index.php |
| カテゴリーアーカイブ         | category-{slug}.php            | category-{id}.php       | category.php            | archive.php    | index.php |
| タグアーカイブ               | tag-{slug}.php                 | tag-{id}.php            | tag.php                 | archive.php    | index.php |
| 作成者アーカイブ             | author-{nicename}.php          | author-{id}.php         | author.php              | archive.php    | index.php |
| 日付別アーカイブ             |                                |                         | date.php                | archive.php    | index.php |
| カスタム投稿タイプアーカイブ |                                |                         | archive-{post_type}.php | archive.php    | index.php |
| カスタム投稿ページ           |                                |                         | single-{post_type}.php  | single.php     | index.php |
| 個別投稿ページ               |                                |                         | single-post.php         | single.php     | index.php |
| 固定ページ                   | ページテンプレート             | page-{slug}.php         | page-{id}.php           | page.php       | index.php |
| フロントページ               |                                |                         |                         | front-page.php | index.php |
| ホーム（トップ）ページ       |                                |                         |                         | home.php       | index.php |


