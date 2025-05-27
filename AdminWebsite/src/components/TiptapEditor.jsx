// src/components/TiptapEditorPro.jsx
import React from 'react';
import { useEditor, EditorContent } from '@tiptap/react';
import StarterKit from '@tiptap/starter-kit';
import Underline from '@tiptap/extension-underline';
import TextAlign from '@tiptap/extension-text-align';
import { Bold, Italic, Underline as UIcon, Heading1, Heading2, List, ListOrdered, AlignLeft, AlignCenter, AlignRight } from 'lucide-react';
import clsx from 'classnames';

import './TiptapEditorPro.css';

export default function TiptapEditorPro({ value, onChange }) {
  const editor = useEditor({
    extensions: [
      StarterKit,
      Underline,
      TextAlign.configure({
        types: ['heading', 'paragraph'],
      }),
    ],
    content: value,
    onUpdate({ editor }) {
      onChange(editor.getHTML());
    },
  });

  if (!editor) return null;

  const Button = ({ onClick, active, icon: Icon, label }) => (
    <button
      onClick={onClick}
      className={clsx('editor-btn', { active })}
      title={label}
    >
      <Icon size={16} />
    </button>
  );

  return (
    <div className="editor-container">
      <div className="editor-toolbar">
        <Button onClick={() => editor.chain().focus().toggleBold().run()} active={editor.isActive('bold')} icon={Bold} label="Bold" />
        <Button onClick={() => editor.chain().focus().toggleItalic().run()} active={editor.isActive('italic')} icon={Italic} label="Italic" />
        <Button onClick={() => editor.chain().focus().toggleUnderline().run()} active={editor.isActive('underline')} icon={UIcon} label="Underline" />
        <Button onClick={() => editor.chain().focus().toggleHeading({ level: 1 }).run()} active={editor.isActive('heading', { level: 1 })} icon={Heading1} label="Heading 1" />
        <Button onClick={() => editor.chain().focus().toggleHeading({ level: 2 }).run()} active={editor.isActive('heading', { level: 2 })} icon={Heading2} label="Heading 2" />
        <Button onClick={() => editor.chain().focus().toggleBulletList().run()} active={editor.isActive('bulletList')} icon={List} label="Bullet List" />
        <Button onClick={() => editor.chain().focus().toggleOrderedList().run()} active={editor.isActive('orderedList')} icon={ListOrdered} label="Ordered List" />
        <Button onClick={() => editor.chain().focus().setTextAlign('left').run()} active={editor.isActive({ textAlign: 'left' })} icon={AlignLeft} label="Align Left" />
        <Button onClick={() => editor.chain().focus().setTextAlign('center').run()} active={editor.isActive({ textAlign: 'center' })} icon={AlignCenter} label="Align Center" />
        <Button onClick={() => editor.chain().focus().setTextAlign('right').run()} active={editor.isActive({ textAlign: 'right' })} icon={AlignRight} label="Align Right" />
      </div>
      <EditorContent editor={editor} className="editor-content" />
    </div>
  );
}
